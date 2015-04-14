NAME = 'chef-cascade'
PREFIX = '/opt'
ITERATION = 1

BUILD_DIR = './build'
KEEP = 2

# Todo fix this ENV hack
if `uname -a`.include? 'Ubuntu'
  Dir.mkdir "#{Dir.pwd}/.gems" unless File.directory? "#{Dir.pwd}/.gems"
  ENV['PATH'] =  "#{Dir.pwd}/.gems/bin:#{ENV['PATH']}"
  ENV['GEM_HOME'] = "#{Dir.pwd}/.gems"
  ENV['GEM_PATH'] = '/opt/chef/embedded/lib/ruby/gems/1.9.1'
end

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

  packages = Dir['./pkg/*'].sort_by{ |f| File.mtime(f) }.reverse

  KEEP.times do
    packages.shift
  end

  packages.each do |pkg|
    File.unlink pkg
  end
end

desc 'build gem'
task :gem do
  sh %{ gem build chef-cascade.gemspec }
end

desc 'build debian package'
task :deb => [:install_deps, :clean, :setup_dir, :copy_build_files] do
  sh %{ fpm -t deb -s dir -n #{NAME} -v #{Cascade::VERSION} -a all --iteration #{ITERATION} -d chef -d libxslt1.1 --deb-user root --deb-group root -C ./build -p ./pkg . }
end

task :default => :deb
