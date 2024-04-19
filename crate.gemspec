# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crate/version'

Gem::Specification.new do |spec|
  spec.name          = "crate"
  spec.version       = Crate::VERSION
  spec.authors       = ["Jeremy Hinegardner"]
  spec.email         = ["jeremy@copiousfreetime.org"]
  spec.summary       = %q{Tool for building and packaging standalone statically compiled ruby appliations}
  spec.homepage      = "http://copiousfreetime.rubyforge.org/crate/"
  spec.license       = "MIT"
  spec.platform     = Gem::Platform::RUBY

  spec.files         = `git ls-files -z`.split("\x0")
  # spec.files         = `git ls-files bin data examples lib spec tasks Rakefile crate.gemspec Gemfile`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # spec.add_runtime_dependency( "configuration", "~> 0.0.5")
  # spec.add_runtime_dependency( "minitar")
  # spec.add_runtime_dependency( "amalgalite", "~> 1.3.0")
  # spec.add_runtime_dependency( "logging", "~> 0.9" )

  # spec.add_development_dependency "bundler", "~> 1.6"
  # spec.add_development_dependency "rake"

  # gems locked for 1.8.7 compatibility
  spec.add_runtime_dependency( "configuration", "1.3.4")
  spec.add_runtime_dependency( "minitar", '0.6')
  spec.add_runtime_dependency( "amalgalite", "0.8.0")
  spec.add_runtime_dependency( "flexmock", "0.8.2" )
  spec.add_runtime_dependency( "logging", "0.9.7" )

  spec.add_development_dependency "bundler", "1.0.15"
  # spec.add_development_dependency "bundler", "~> 1.6"
  # spec.add_development_dependency "rake", "0.9.2.2"
  # spec.add_development_dependency "rake", "~> 0.9"

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
