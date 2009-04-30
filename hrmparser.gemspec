# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{hrmparser}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Oren Teich"]
  s.date = %q{2009-04-29}
  s.description = %q{A ruby parser for polar and garmin hrm}
  s.email = ["oren@teich.net"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "lib/hrmparser.rb", "lib/hrmparser/arraymath.rb", "lib/hrmparser/workout.rb", "lib/hrmparser/version.rb", "lib/hrmparser/trackpoint.rb", "lib/hrmparser/importer.rb", "lib/hrmparser/importer/garmin.rb", "lib/hrmparser/importer/polar.rb", "script/console", "script/destroy", "script/generate", "spec/hrmparser_spec.rb", "spec/arraymath_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/rspec.rake"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/teich/hrmparser/tree/master}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{hrmparser}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A ruby parser for polar and garmin hrm}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<newgem>, [">= 1.3.0"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<newgem>, [">= 1.3.0"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<newgem>, [">= 1.3.0"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
