#
# Author:: Zachary Schneider (<zachary.schneider@instana.com>)
# Copyright:: Copyright (c) 2016 Instana, Inc.
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

require 'highline'

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

  option :skip_meta,
    :short        => "-m",
    :long         => "--skip-metadata-update",
    :description  => "Skip metadata update",
    :boolean      => true,
    :default      => false

  option :skip_packages,
    :short        => "-s",
    :long         => "--skip-package-update",
    :description  => "Skip package update",
    :boolean      => true,
    :default      => false

  option :ref_id,
    :short => "-R REFERENCE_ID",
    :long => "--ref REFERENCE_ID",
    :description => "Reference ID for tracking"

  option :roles,
    :short => "-r Role,Role",
    :long => "--roles Role,Role",
    :description => "Roles for runlist",
    :proc => lambda{|roles|
      roles = roles.split(',')
    },
    :default => (::File.exists?('/etc/chef/roles.yml')) ? YAML.load_file('/etc/chef/roles.yml') : []

  option :phase,
    :short        => "-p PHASE",
    :long         => "--phase PHASE",
    :description  => "Set the chef run phase (all, update, config)",
    :proc         => lambda { |l| l.to_sym },
    :default      => :all


  attr_reader :chef_client_json
  attr_reader :output_color
  attr_reader :hostname
  attr_reader :pm_flavor

  def initialize
    super
  end

  def reconfigure
    super

    Chef::Config[:solo] = true
    Chef::Config[:solo_legacy_mode] = true
    Chef::Config[:audit_mode] = :disabled  
    Chef::Config[:cascade_state_dir] = '/var/chef/cascade/state'

    FileUtils::mkdir_p ::Cascade::State::STATE_DIR
    FileUtils.chmod 0750, ::Cascade::State::STATE_DIR

    @output_color = Chef::Config[:color] ? :green : :none
    
    # TODO tried ohai but had to load it twice (obvious) Fix this
    @hostname = Mixlib::ShellOut.new('hostname --long').run_command.stdout.strip

    # Define handler
    cascade_handler = Chef::Handler::CascadeHandler.new
    Chef::Config[:start_handlers] << cascade_handler
    Chef::Config[:report_handlers] << cascade_handler
    Chef::Config[:exception_handlers] << cascade_handler

    # Set roles and node attributes
    client_config = {}
    client_config['run_list'] = get_roles 
    client_config.merge! ::Cascade::KeyValue.get("/cascade/nodes/#{@hostname}/attrs")
    client_config.merge! get_attrs
    @chef_client_json = client_config
    
    case
    when Mixlib::ShellOut.new('which yum').run_command.status.success?
      @pm_flavor = :yum
    when Mixlib::ShellOut.new('which apt-get').run_command.status.success?
      @pm_flavor = :apt
    else
      @pm_flavor = nil
    end

    # Update package metadata
    if Chef::Config[:skip_packages] == false && Chef::Config[:phase] != :config
      event = Hashie::Mash.new(
        name: 'cascade.cm',
        source: @hostname,
        ref: Chef::Config[:ref_id],
        msg: 'meta'
      )
      ::Cascade::Event.fire(event)

      if Chef::Config[:skip_meta] == false
        if Chef::Config[:packages] and supported? 
          yum_update if @pm_flavor == :yum
          
          apt_update if @pm_flavor == :apt
        else
          Chef::Log.error "Package installs only supported on Linux via (apt/yum)"
        end
      end

      # Install updated packages
      if Chef::Config[:packages] and supported? 
        yum_packages if @pm_flavor == :yum
        
        apt_packages if @pm_flavor == :apt
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

  # General functionality

  def get_roles
    out "Local roles utilized: #{Chef::Config[:roles].join(",")}" unless Chef::Config[:roles].empty?
    roles = (Chef::Config[:roles].empty?) ? ::Cascade::Role.get() : Chef::Config[:roles]
    roles.map{|role| "role[#{role}]"}
  end

  def get_attrs
    ::File.exists?('/etc/chef/attrs.yml') ? YAML.load_file('/etc/chef/attrs.yml') : {}
  end

  def out(message)
    $stdout.puts HighLine.color(message, @output_color)
  end

  def supported?
    return RUBY_PLATFORM.include? 'linux'
  end

  # Package systems
  # Would love to use chef primitives here, but using them outside of chef
  # is not an option due to the way run_context is managed

  def apt_update
    out "Updating package repository metadata..."
    Mixlib::ShellOut.new('apt-get update').run_command
  end

  def apt_packages
    Chef::Config[:packages].each do |pkg|
      cmd = Mixlib::ShellOut.new("apt-get install -y #{pkg}")
      cmd.environment = {'LANG' => 'C'}
      cmd.run_command
      
      if cmd.status.to_i != 0 
        Chef::Log.error("failed to upgrade #{pkg}")
        next
      end
      
      unless cmd.stdout.include? 'already the newest version'
        out "Upgraded #{pkg} to #{cmd.stdout[/^Setting.*$/][/\(.*\)/]}" 
        
        # Replace immediately
        exec "#{$0} #{ARGV.join(' ')} -m" if pkg == 'chef-cascade'
      end
    end
  end

  def yum_update
    out "Updating package repository metadata..."
    Mixlib::ShellOut.new('yum makecache -y fast').run_command
  end

  def yum_packages
    Chef::Config[:packages].each do |pkg|
      cmd = Mixlib::ShellOut.new("yum install -y #{pkg}")
      cmd.environment = {'LANG' => 'C'}
      cmd.run_command
      
      if cmd.status.to_i != 0 
        Chef::Log.error("failed to upgrade #{pkg}")
        next
      end
      
      unless cmd.stdout.include? 'Nothing to do'
        out "Upgraded #{pkg} to #{cmd.stdout[/^(Updated|Installed):.*\n.*/].split(' ').last}"
        # Replace immediately
        exec "#{$0} #{ARGV.join(' ')} -m" if pkg == 'chef-cascade'
      end
    end
  end
end
