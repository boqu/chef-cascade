# -*- encoding: utf-8 -*-
# stub: mixlib-cli 1.7.0 ruby lib

Gem::Specification.new do |s|
  s.name = "mixlib-cli"
  s.version = "1.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Chef Software, Inc."]
  s.date = "2016-07-06"
  s.description = "A simple mixin for CLI interfaces, including option parsing"
  s.email = "info@chef.io"
  s.extra_rdoc_files = ["README.md", "LICENSE", "NOTICE"]
  s.files = ["LICENSE", "NOTICE", "README.md"]
  s.homepage = "https://www.chef.io"
  s.licenses = ["Apache-2.0"]
  s.rubygems_version = "2.5.1"
  s.summary = "A simple mixin for CLI interfaces, including option parsing"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["< 11.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.14"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
      s.add_development_dependency(%q<chefstyle>, ["~> 0.3"])
    else
      s.add_dependency(%q<rake>, ["< 11.0"])
      s.add_dependency(%q<rspec>, ["~> 2.14"])
      s.add_dependency(%q<rdoc>, [">= 0"])
      s.add_dependency(%q<chefstyle>, ["~> 0.3"])
    end
  else
    s.add_dependency(%q<rake>, ["< 11.0"])
    s.add_dependency(%q<rspec>, ["~> 2.14"])
    s.add_dependency(%q<rdoc>, [">= 0"])
    s.add_dependency(%q<chefstyle>, ["~> 0.3"])
  end
end
