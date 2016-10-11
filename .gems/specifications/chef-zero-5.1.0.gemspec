# -*- encoding: utf-8 -*-
# stub: chef-zero 5.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "chef-zero"
  s.version = "5.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["John Keiser"]
  s.date = "2016-09-07"
  s.description = "Self-contained, easy-setup, fast-start in-memory Chef server for testing and solo setup purposes"
  s.email = "jkeiser@chef.io"
  s.executables = ["chef-zero"]
  s.files = ["bin/chef-zero"]
  s.homepage = "http://www.chef.io"
  s.licenses = ["Apache 2.0"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.2.2")
  s.rubygems_version = "2.5.1"
  s.summary = "Self-contained, easy-setup, fast-start in-memory Chef server for testing and solo setup purposes"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mixlib-log>, ["~> 1.3"])
      s.add_runtime_dependency(%q<hashie>, ["< 4.0", ">= 2.0"])
      s.add_runtime_dependency(%q<uuidtools>, ["~> 2.1"])
      s.add_runtime_dependency(%q<ffi-yajl>, ["~> 2.2"])
      s.add_runtime_dependency(%q<rack>, ["~> 2.0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<pry-byebug>, [">= 0"])
      s.add_development_dependency(%q<pry-stack_explorer>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<mixlib-log>, ["~> 1.3"])
      s.add_dependency(%q<hashie>, ["< 4.0", ">= 2.0"])
      s.add_dependency(%q<uuidtools>, ["~> 2.1"])
      s.add_dependency(%q<ffi-yajl>, ["~> 2.2"])
      s.add_dependency(%q<rack>, ["~> 2.0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<pry-byebug>, [">= 0"])
      s.add_dependency(%q<pry-stack_explorer>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<mixlib-log>, ["~> 1.3"])
    s.add_dependency(%q<hashie>, ["< 4.0", ">= 2.0"])
    s.add_dependency(%q<uuidtools>, ["~> 2.1"])
    s.add_dependency(%q<ffi-yajl>, ["~> 2.2"])
    s.add_dependency(%q<rack>, ["~> 2.0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<pry-byebug>, [">= 0"])
    s.add_dependency(%q<pry-stack_explorer>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
