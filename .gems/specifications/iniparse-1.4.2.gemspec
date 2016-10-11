# -*- encoding: utf-8 -*-
# stub: iniparse 1.4.2 ruby lib

Gem::Specification.new do |s|
  s.name = "iniparse"
  s.version = "1.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Anthony Williams"]
  s.date = "2015-12-03"
  s.description = "A pure Ruby library for parsing INI documents. Preserves the structure of the original document, including whitespace and comments"
  s.email = "hi@antw.me"
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = ["LICENSE", "README.rdoc"]
  s.homepage = "http://github.com/antw/iniparse"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubyforge_project = "iniparse"
  s.rubygems_version = "2.5.1"
  s.summary = "A pure Ruby library for parsing INI documents."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.14"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.14"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.14"])
  end
end
