# -*- encoding: utf-8 -*-
# stub: chef-config 12.14.89 ruby lib

Gem::Specification.new do |s|
  s.name = "chef-config"
  s.version = "12.14.89"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Adam Jacob"]
  s.date = "2016-09-22"
  s.email = ["adam@chef.io"]
  s.homepage = "https://github.com/chef/chef"
  s.licenses = ["Apache-2.0"]
  s.rubygems_version = "2.5.1"
  s.summary = "Chef's default configuration and config loading"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mixlib-shellout>, ["~> 2.0"])
      s.add_runtime_dependency(%q<mixlib-config>, ["~> 2.0"])
      s.add_runtime_dependency(%q<fuzzyurl>, [">= 0"])
      s.add_runtime_dependency(%q<addressable>, [">= 0"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<rspec-core>, ["~> 3.2"])
      s.add_development_dependency(%q<rspec-expectations>, ["~> 3.2"])
      s.add_development_dependency(%q<rspec-mocks>, ["~> 3.2"])
    else
      s.add_dependency(%q<mixlib-shellout>, ["~> 2.0"])
      s.add_dependency(%q<mixlib-config>, ["~> 2.0"])
      s.add_dependency(%q<fuzzyurl>, [">= 0"])
      s.add_dependency(%q<addressable>, [">= 0"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<rspec-core>, ["~> 3.2"])
      s.add_dependency(%q<rspec-expectations>, ["~> 3.2"])
      s.add_dependency(%q<rspec-mocks>, ["~> 3.2"])
    end
  else
    s.add_dependency(%q<mixlib-shellout>, ["~> 2.0"])
    s.add_dependency(%q<mixlib-config>, ["~> 2.0"])
    s.add_dependency(%q<fuzzyurl>, [">= 0"])
    s.add_dependency(%q<addressable>, [">= 0"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<rspec-core>, ["~> 3.2"])
    s.add_dependency(%q<rspec-expectations>, ["~> 3.2"])
    s.add_dependency(%q<rspec-mocks>, ["~> 3.2"])
  end
end
