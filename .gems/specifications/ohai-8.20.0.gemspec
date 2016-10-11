# -*- encoding: utf-8 -*-
# stub: ohai 8.20.0 ruby lib

Gem::Specification.new do |s|
  s.name = "ohai"
  s.version = "8.20.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Adam Jacob"]
  s.date = "2016-09-07"
  s.description = "Ohai profiles your system and emits JSON"
  s.email = "adam@chef.io"
  s.executables = ["ohai"]
  s.files = ["bin/ohai"]
  s.homepage = "https://docs.chef.io/ohai.html"
  s.licenses = ["Apache-2.0"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.1.0")
  s.rubygems_version = "2.5.1"
  s.summary = "Ohai profiles your system and emits JSON"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<systemu>, ["~> 2.6.4"])
      s.add_runtime_dependency(%q<ffi-yajl>, ["~> 2.2"])
      s.add_runtime_dependency(%q<mixlib-cli>, [">= 0"])
      s.add_runtime_dependency(%q<mixlib-config>, ["~> 2.0"])
      s.add_runtime_dependency(%q<mixlib-log>, ["< 2.0", ">= 1.7.1"])
      s.add_runtime_dependency(%q<mixlib-shellout>, ["~> 2.0"])
      s.add_runtime_dependency(%q<plist>, ["~> 3.1"])
      s.add_runtime_dependency(%q<ipaddress>, [">= 0"])
      s.add_runtime_dependency(%q<wmi-lite>, ["~> 1.0"])
      s.add_runtime_dependency(%q<ffi>, ["~> 1.9"])
      s.add_runtime_dependency(%q<chef-config>, ["< 13", ">= 12.5.0.alpha.1"])
      s.add_development_dependency(%q<rake>, ["< 12.0.0", ">= 10.1.0"])
      s.add_development_dependency(%q<rspec-core>, ["~> 3.0"])
      s.add_development_dependency(%q<rspec-expectations>, ["~> 3.0"])
      s.add_development_dependency(%q<rspec-mocks>, ["~> 3.0"])
      s.add_development_dependency(%q<rspec-collection_matchers>, ["~> 1.0"])
      s.add_development_dependency(%q<rspec_junit_formatter>, [">= 0"])
      s.add_development_dependency(%q<github_changelog_generator>, ["= 1.13.1"])
      s.add_development_dependency(%q<rack>, ["~> 1.0"])
    else
      s.add_dependency(%q<systemu>, ["~> 2.6.4"])
      s.add_dependency(%q<ffi-yajl>, ["~> 2.2"])
      s.add_dependency(%q<mixlib-cli>, [">= 0"])
      s.add_dependency(%q<mixlib-config>, ["~> 2.0"])
      s.add_dependency(%q<mixlib-log>, ["< 2.0", ">= 1.7.1"])
      s.add_dependency(%q<mixlib-shellout>, ["~> 2.0"])
      s.add_dependency(%q<plist>, ["~> 3.1"])
      s.add_dependency(%q<ipaddress>, [">= 0"])
      s.add_dependency(%q<wmi-lite>, ["~> 1.0"])
      s.add_dependency(%q<ffi>, ["~> 1.9"])
      s.add_dependency(%q<chef-config>, ["< 13", ">= 12.5.0.alpha.1"])
      s.add_dependency(%q<rake>, ["< 12.0.0", ">= 10.1.0"])
      s.add_dependency(%q<rspec-core>, ["~> 3.0"])
      s.add_dependency(%q<rspec-expectations>, ["~> 3.0"])
      s.add_dependency(%q<rspec-mocks>, ["~> 3.0"])
      s.add_dependency(%q<rspec-collection_matchers>, ["~> 1.0"])
      s.add_dependency(%q<rspec_junit_formatter>, [">= 0"])
      s.add_dependency(%q<github_changelog_generator>, ["= 1.13.1"])
      s.add_dependency(%q<rack>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<systemu>, ["~> 2.6.4"])
    s.add_dependency(%q<ffi-yajl>, ["~> 2.2"])
    s.add_dependency(%q<mixlib-cli>, [">= 0"])
    s.add_dependency(%q<mixlib-config>, ["~> 2.0"])
    s.add_dependency(%q<mixlib-log>, ["< 2.0", ">= 1.7.1"])
    s.add_dependency(%q<mixlib-shellout>, ["~> 2.0"])
    s.add_dependency(%q<plist>, ["~> 3.1"])
    s.add_dependency(%q<ipaddress>, [">= 0"])
    s.add_dependency(%q<wmi-lite>, ["~> 1.0"])
    s.add_dependency(%q<ffi>, ["~> 1.9"])
    s.add_dependency(%q<chef-config>, ["< 13", ">= 12.5.0.alpha.1"])
    s.add_dependency(%q<rake>, ["< 12.0.0", ">= 10.1.0"])
    s.add_dependency(%q<rspec-core>, ["~> 3.0"])
    s.add_dependency(%q<rspec-expectations>, ["~> 3.0"])
    s.add_dependency(%q<rspec-mocks>, ["~> 3.0"])
    s.add_dependency(%q<rspec-collection_matchers>, ["~> 1.0"])
    s.add_dependency(%q<rspec_junit_formatter>, [">= 0"])
    s.add_dependency(%q<github_changelog_generator>, ["= 1.13.1"])
    s.add_dependency(%q<rack>, ["~> 1.0"])
  end
end
