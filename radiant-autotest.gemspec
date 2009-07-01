# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{radiant-autotest}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Josh French"]
  s.date = %q{2009-07-01}
  s.email = %q{josh@digitalpulp.com}
  s.summary = "Autotest runner for Radiant extensions"
  s.description = "Autotest runner for Radiant extensions"
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/autotest/discover.rb",
     "lib/autotest/radiant.rb",
     "lib/autotest/radiant/growl.rb",
     "lib/fail.png",
     "lib/pass.png",
     "radiant-autotest.gemspec",
     "spec/lib/radiant_autotest_spec.rb",
     "spec/matchers/autotest_matchers.rb"
  ]
  s.homepage = %q{http://github.com/jfrench/radiant-autotest}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Autotest mappings for Radiant extensions}
  s.test_files = [
    "spec/lib/radiant_autotest_spec.rb",
     "spec/matchers/autotest_matchers.rb"
  ]
  s.add_dependency 'ZenTest', '>= 3.9.0'
  s.add_dependency 'rspec' # version mainly dependent on Radiant

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
