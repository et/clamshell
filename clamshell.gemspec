# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "clamshell/version"

Gem::Specification.new do |s|
  s.name        = "clamshell"
  s.version     = Clamshell::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Eric Thomas"]
  s.email       = ["eric.l.m.thomas@gmail.com"]
  s.homepage    = "https://github.com/et/clamshell"
  s.summary     = %q{Clamshell manages your environment in a shell-independent setup.}
  s.description = %q{Clamshell allows you to setup shell statements which configure
                     your project's environment that doesn't care about which shell
                     (bash, tcsh) the target user will be using.}

  s.rubyforge_project = "clamshell"

  s.add_dependency('grit')

  s.add_development_dependency('rspec')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
