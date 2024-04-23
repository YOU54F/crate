# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crate/version'
# require 'rubygems'
# require 'crate/version'
# require 'tasks/config'

Crate::GEM_SPEC = Gem::Specification.new do |spec|
  # proj = Configuration.for('project')
  spec.name         = "crate"
  spec.version      = Crate::VERSION
  spec.author       = "Jeremy Hinegardner"
  spec.email        = "jeremy@copiousfreetime.org"
  spec.homepage     = "http://copiousfreetime.rubyforge.org/crate/"
  spec.summary      = %q{Tool for building and packaging standalone statically compiled ruby appliations}
  # spec.description  = proj.description
  spec.license  = "MIT"
  spec.platform     = Gem::Platform::RUBY


  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  # add dependencies here
  spec.add_dependency( "configuration", "~> 0.0.5")
  spec.add_dependency( "archive-tar-minitar")
  spec.add_dependency( "amalgalite", "~> 0.9")
  spec.add_dependency( "logging", "~> 0.9" )
  spec.add_dependency( "tap", "= 0.12.4")

  spec.add_development_dependency( "rake", "~> 0.8.3")

  # if rdoc = Configuration.for_if_exist?('rdoc') then
  #   spec.has_rdoc         = true
  #   spec.extra_rdoc_files = pkg.files.rdoc
  #   spec.rdoc_options     = rdoc.options + [ "--main" , rdoc.main_page ]
  # else
  #   spec.has_rdoc         = false
  # end

  # if test = Configuration.for_if_exist?('testing') then
  #   spec.test_files       = test.files
  # end

  # if rf = Configuration.for_if_exist?('rubyforge') then
  #   spec.rubyforge_project  = rf.project
  # end

end
