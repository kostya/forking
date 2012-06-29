# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + "/lib/version"

Gem::Specification.new do |s|
  s.name = %q{forking}
  s.version = Forking::VERSION

  s.authors = ["Makarchev Konstantin"]
 
  s.description = %q{Simple processes forking, and restarting. Master process starts as daemon.}
  s.summary = %q{Simple processes forking, and restarting. Master process starts as daemon.}

  s.email = %q{kostya27@gmail.com}
  s.homepage = %q{http://github.com/kostya/forking}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'daemon-spawn'
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
  
end