NAME = 'chef-cascade'
PREFIX = '/opt'
ITERATION = 0
DESCRIPTION = 'An opinionated chef-client'

BUILD_DIR = './build'

CASCADE_RUBY = ENV['CASCADE_RUBY'] || 'ruby'

# Setup RUBY ENV
ENV['PATH'] =  "#{Dir.pwd}/.gems/bin:#{ENV['PATH']}"
ENV['GEM_HOME'] = "#{Dir.pwd}/.gems"

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
  sh %{ mkdir -p #{BUILD_DIR}/etc/profile.d }
  sh %{ mkdir -p #{BUILD_DIR}/etc/cascade }
  sh %{ mkdir -p #{BUILD_DIR}/etc/chef }
  sh %{ mkdir -p ./pkg }
end

desc 'Install Dependencies'
task :install_deps do
  sh %{ gem install bundler -v 2.3.26}
  sh %{ bundle update }
  sh %{ bundle clean --force }
end

task :copy_build_files do
  sh %{ cp -Rp ./lib  #{BUILD_DIR}#{PREFIX}/#{NAME} }
  sh %{ cp -Rp ./.gems  #{BUILD_DIR}#{PREFIX}/#{NAME}/gems }
  sh %{ cp -Rp ./bin/*  #{BUILD_DIR}/usr/bin }
  sh %{ cp -Rp ./profile.sh #{BUILD_DIR}/etc/profile.d/chef-cascade.sh }
end

desc 'build gem'
task :gem do
  sh %{ gem build chef-cascade.gemspec }
end

desc 'munge bin'
task :munge_bin do
  if CASCADE_RUBY != 'ruby'
    sh %{ sed -i 's /usr/bin/env\\  /opt/#{CASCADE_RUBY}/bin/ ' #{BUILD_DIR}#{PREFIX}/#{NAME}/gems/bin/* }
    sh %{ sed -i 's /usr/bin/env\\  /opt/#{CASCADE_RUBY}/bin/ ' #{BUILD_DIR}/usr/bin/* }
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
      -d #{CASCADE_RUBY} \
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
      -d #{CASCADE_RUBY} \
      --deb-user root \
      --deb-group root \
      -C ./build \
      -p ./pkg .
  }
end

desc 'Sign RPM'
task :sign_rpm do
  if ENV['SIGN_RPM'] == "true"
    rpms = Rake::FileList["./pkg/*.rpm"]
    rpms.each do |rpm|
      sh %{ /usr/bin/expect -c 'spawn rpm --addsign #{rpm}; expect -exact "Enter pass phrase: "; send -- "\r"; expect eof' }
    end
  end
end

task default: [ :clean, :setup_dir, :install_deps, :copy_build_files, :munge_bin, :deb, :rpm, :sign_rpm ]
