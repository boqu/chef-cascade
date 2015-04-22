#
# Author:: Zachary Schneider (<schneider@boundary.com>)
# Copyright:: Copyright (c) 2015 Boundary, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'chef'
require 'chef/application'
require 'chef/client'
require 'chef/config'
require 'chef/daemon'
require 'chef/log'
require 'chef/rest'
require 'chef/config_fetcher'
require 'fileutils'
require 'highline'
require 'zk'
require 'postgres-pr/connection'
require 'mysql'
require 'cascade'
require 'chef/handler/cascade_handler'

class Chef::Application::Cascade < Chef::Application

  option :config_file,
    :short => "-c CONFIG",
    :long  => "--config CONFIG",
    :default => Chef::Config.platform_specific_path('/etc/chef/cascade.rb'),
    :description => "The configuration file to use"

  option :formatter,
    :short        => "-F FORMATTER",
    :long         => "--format FORMATTER",
    :description  => "output format to use",
    :proc         => lambda { |format| Chef::Config.add_formatter(format) }

  option :force_logger,
    :long         => "--force-logger",
    :description  => "Use logger output instead of formatter output",
    :boolean      => true,
    :default      => false

  option :force_formatter,
    :long         => "--force-formatter",
    :description  => "Use formatter output instead of logger output",
    :boolean      => true,
    :default      => false

  option :color,
    :long         => '--[no-]color',
    :boolean      => true,
    :default      => !Chef::Platform.windows?,
    :description  => "Use colored output, defaults to enabled"

  option :log_level,
    :short        => "-l LEVEL",
    :long         => "--log_level LEVEL",
    :description  => "Set the log level (debug, info, warn, error, fatal)",
    :proc         => lambda { |l| l.to_sym }

  option :log_location,
    :short        => "-L LOGLOCATION",
    :long         => "--logfile LOGLOCATION",
    :description  => "Set the log file location, defaults to STDOUT",
    :proc         => nil

  option :help,
    :short        => "-h",
    :long         => "--help",
    :description  => "Show this message",
    :on           => :tail,
    :boolean      => true,
    :show_options => true,
    :exit         => 0

  option :user,
    :short => "-u USER",
    :long => "--user USER",
    :description => "User to set privilege to",
    :proc => nil

  option :group,
    :short => "-g GROUP",
    :long => "--group GROUP",
    :description => "Group to set privilege to",
    :proc => nil

  option :node_name,
    :short => "-N NODE_NAME",
    :long => "--node-name NODE_NAME",
    :description => "The node name for this client",
    :proc => nil

  option :version,
    :short        => "-v",
    :long         => "--version",
    :description  => "Show chef version",
    :boolean      => true,
    :proc         => lambda {|v| puts "Chef: #{::Chef::VERSION}"},
    :exit         => 0

  option :override_runlist,
    :short        => "-o RunlistItem,RunlistItem...",
    :long         => "--override-runlist RunlistItem,RunlistItem...",
    :description  => "Replace current run list with specified items",
    :proc         => lambda{|items|
      items = items.split(',')
      items.compact.map{|item|
        Chef::RunList::RunListItem.new(item)
      }
    }

  option :client_fork,
    :short        => "-f",
    :long         => "--[no-]fork",
    :description  => "Fork client",
    :boolean      => true

  option :why_run,
    :short        => '-W',
    :long         => '--why-run',
    :description  => 'Enable whyrun mode',
    :boolean      => true

  option :environment,
    :short        => '-E ENVIRONMENT',
    :long         => '--environment ENVIRONMENT',
    :description  => 'Set the Chef Environment on the node'

  option :run_lock_timeout,
    :long         => "--run-lock-timeout SECONDS",
    :description  => "Set maximum duration to wait for another client run to finish, default is indefinitely.",
    :proc         => lambda { |s| s.to_i }

  option :skip_packages,
    :short        => "-s",
    :long         => "--skip-packages",
    :description  => "Skip package updates",
    :boolean      => true,
    :default      => false

  option :ref_id,
    :short => "-r REFERENCE_ID",
    :long => "--ref REFERENCE_ID",
    :description => "Reference ID for tracking"

  attr_reader :chef_client_json
  attr_reader :output_color

  def initialize
    super
  end

  def reconfigure
    super

    Chef::Config[:solo] = true

    @output_color = Chef::Config[:color] ? :green : :none

    # Define handler
    cascade_handler = Chef::Handler::CascadeHandler.new

    Chef::Config[:start_handlers] << cascade_handler
    Chef::Config[:report_handlers] << cascade_handler
    Chef::Config[:exception_handlers] << cascade_handler

    # Get roles
    # TODO tried ohai but had to load it twice (obvious) Fix this
    client_json = {}
    client_json['run_list'] = ::Cascade::Role.get(`hostname --long`.strip).map{|role| "role[#{role}]"} 

    @chef_client_json = client_json
  
    # Package Preinstall handling
    if Chef::Config[:skip_packages] == false
      
      event = Hashie::Mash.new
      event.name = 'cascade.cm'
      event.source = run_status.node.name
      event.ref = Chef::Config[:ref_id]
      event.status = 'meta'
      ::Cascade::Event.fire(event)

      if Chef::Config[:packages] and supported? 
        yum_packages if Mixlib::ShellOut.new('which yum').run_command.status.success?
          
        apt_packages if Mixlib::ShellOut.new('which apt-get').run_command.status.success?
      else
        Chef::Log.error "Package installs only supported on Linux via (apt/yum)"
      end
    end
  end

  def setup_application
    Chef::Daemon.change_privilege
  end

  def run_application
    
    begin
      run_chef_client
    rescue SystemExit => e
      raise
    rescue Exception => e 
      Chef::Application.fatal!("#{e.class}: #{e.message}", 1)
    end
  end

  private

  def supported?
    return RUBY_PLATFORM.include? 'linux'
  end

  def out(message)
    $stdout.puts HighLine.color(message, @output_color)
  end

  def yum_packages
    Chef::Log.error "Yum support not implemented"
  end

  def apt_packages
    out "Updating package repository metadata..."
    Mixlib::ShellOut.new('apt-get update').run_command

    upgraded = []

    Chef::Config[:packages].each do |pkg|
      cmd = Mixlib::ShellOut.new("apt-get install -y #{pkg}")
      cmd.run_command
      
      next if cmd.status.to_i != 0 # TODO don't fail silently 
      
      unless cmd.stdout.include? 'already the newest version'
        out "Upgraded #{pkg} to #{cmd.stdout[/^Setting.*$/][/\(.*\)/]}" 
        
        upgraded << pkg
      end

      # Replace process if chef or cascade package is upgraded
      exec "#{$0} #{ARGV.join(' ')} -s" if upgraded.include?('chef') or upgraded.include?('chef-cascade')
    end
  end
end
