# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{hrmparser}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Oren Teich"]
  s.date = %q{2009-07-25}
  s.description = %q{Parses Polar and Garmin HRM files.}
  s.email = %q{oren@teich.net}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "CHANGELOG.txt",
     "README.rdoc",
     "Rakefile",
     "VERSION.yml",
     "hrmparser.gemspec",
     "lib/hrmparser.rb",
     "lib/hrmparser/arraymath.rb",
     "lib/hrmparser/importer.rb",
     "lib/hrmparser/importer/garmin.rb",
     "lib/hrmparser/importer/gpx.rb",
     "lib/hrmparser/importer/polar.rb",
     "lib/hrmparser/importer/suunto.rb",
     "lib/hrmparser/trackpoint.rb",
     "lib/hrmparser/workout.rb",
     "spec/arraymath_spec.rb",
     "spec/hrmparser_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/teich/hrmparser}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Heart Rate Monitor Parser}
  s.test_files = [
    "spec/arraymath_spec.rb",
     "spec/hrmparser_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
