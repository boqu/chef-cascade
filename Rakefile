NAME = 'chef-cascade'
PREFIX = '/opt'
ITERATION = 3
DESCRIPTION = 'An opinionated chef-client'

BUILD_DIR = './build'

# Setup RUBY ENV
ENV['PATH'] =  "#{Dir.pwd}/.gems/bin:#{ENV['PATH']}"
ENV['GEM_HOME'] = "#{Dir.pwd}/.gems"
ENV['GEM_PATH'] = '/var/lib/gems/2.3.0'

$:.unshift './lib'

require 'cascade/version'

desc 'Install Dependencies'
task :install_deps do
  sh %{ bundle update }
  sh %{ bundle clean --force }
end

task :setup_dir do
  sh %{ mkdir -p #{BUILD_DIR}#{PREFIX}/#{NAME} }
  sh %{ mkdir -p #{BUILD_DIR}/usr/bin }
  sh %{ mkdir -p #{BUILD_DIR}/etc/cascade }
  sh %{ mkdir -p ./pkg }
end

task :copy_build_files do
  sh %{ cp -Rp ./lib  #{BUILD_DIR}#{PREFIX}/#{NAME} }
  sh %{ cp -Rp ./.gems  #{BUILD_DIR}#{PREFIX}/#{NAME}/gems }
  sh %{ cp -Rp ./bin/*  #{BUILD_DIR}/usr/bin }
end

desc 'clean'
task :clean do
  sh %{ rm -rf ./build }
  sh %{ rm -rf ./pkg/* }
  sh %{ rm -rf *.gem }
end

desc 'build gem'
task :gem do
  sh %{ gem build chef-cascade.gemspec }
end

desc 'build debian package'
task :deb => [:install_deps, :clean, :setup_dir, :copy_build_files] do
  sh %{ 
    fpm -t deb -s dir -n #{NAME} \
      -v #{Cascade::VERSION} \
      --description '#{DESCRIPTION}' \
      -a all \
      --iteration #{ITERATION} \
      -d chef \
      --deb-user root \
      --deb-group root \
      -C ./build \
      -p ./pkg .
  }
end

task :default => :deb
