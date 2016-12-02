NAME = 'chef-cascade'
PREFIX = '/opt'
ITERATION = 0
DESCRIPTION = 'An opinionated chef-client'

BUILD_DIR = './build'

CASCADE_RUBY = ENV['CASCADE_RUBY'] || 'ruby'

# Setup RUBY ENV
ENV['PATH'] =  "#{Dir.pwd}/.gems/bin:#{ENV['PATH']}"
ENV['GEM_HOME'] = "#{Dir.pwd}/.gems"

if RUBY == 'ruby'
  ENV['GEM_PATH'] = '/var/lib/gems/2.3.0'
else
  ENV['GEM_PATH'] = "/opt/#{RUBY}/lib/gems/2.3.0"
end

$:.unshift './lib'

require 'cascade/version'

desc 'clean'
task :clean do
  sh %{ rm -rf ./build }
  sh %{ rm -rf ./pkg/* }
  sh %{ rm -rf *.gem }
end

task :setup_dir do
  sh %{ mkdir -p .gems } unless Dir.exist?('.gems')
  sh %{ mkdir -p #{BUILD_DIR}#{PREFIX}/#{NAME} }
  sh %{ mkdir -p #{BUILD_DIR}/usr/bin }
  sh %{ mkdir -p #{BUILD_DIR}/etc/cascade }
  sh %{ mkdir -p #{BUILD_DIR}/etc/chef }
  sh %{ mkdir -p ./pkg }
end

desc 'Install Dependencies'
task :install_deps do
  sh %{ gem install bundler } if CASCADE_RUBY == 'ruby'
  sh %{ bundle update }
  sh %{ bundle clean --force }
end

task :copy_build_files do
  sh %{ cp -Rp ./lib  #{BUILD_DIR}#{PREFIX}/#{NAME} }
  sh %{ cp -Rp ./.gems  #{BUILD_DIR}#{PREFIX}/#{NAME}/gems }
  sh %{ cp -Rp ./bin/*  #{BUILD_DIR}/usr/bin }
end

desc 'build gem'
task :gem do
  sh %{ gem build chef-cascade.gemspec }
end

desc 'munge bin'
task :munge_bin do
  if CASCADE_RUBY != 'ruby'
    sh %{ sed -i 's /usr/bin/env\  /opt/#{RUBY}/bin/ ' #{BUILD_DIR}#{PREFIX}/#{NAME}/gems/bin/* }
    sh %{ sed -i 's /usr/bin/env\  /opt/#{RUBY}/bin/ ' #{BUILD_DIR}#{PREFIX}/#{NAME}/bin/* }
  end
end

desc 'build debian package'
task :deb do
  sh %{ 
    fpm -t deb -s dir -n #{NAME} \
      -v #{Cascade::VERSION} \
      --description '#{DESCRIPTION}' \
      -a amd64 \
      --iteration #{ITERATION} \
      -d #{RUBY} \
      --conflicts chef \
      --deb-user root \
      --deb-group root \
      -C ./build \
      -p ./pkg .
  }
end

desc 'build rpm package'
task :rpm do
  sh %{ 
    fpm -t rpm -s dir -n #{NAME} \
      -v #{Cascade::VERSION} \
      --description '#{DESCRIPTION}' \
      -a x86_64 \
      --iteration #{ITERATION} \
      -d #{RUBY} \
      --conflicts chef \
      --deb-user root \
      --deb-group root \
      -C ./build \
      -p ./pkg .
  }
end

task default: [ :clean, :setup_dir, :install_deps, :copy_build_files, :munge_bin, :deb, :rpm ]
