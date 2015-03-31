# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name        = "fluent-plugin-eventlastvalue"
  gem.version     = "0.0.1"
  gem.authors     = ["Michael Arick", "Change.org"]
  gem.email       = ["marick@change.org"]
  gem.homepage    = "https://github.com/change/fluent-plugin-eventlastvalue"
  gem.summary     = %q{Fluentd plugin to find the last value in a time-period of a field and emit it or write it to redis}
  gem.description = %q{Fluentd plugin to find the last value in a time-period of a field and emit it or write it to redis}
  gem.license     = "MIT"

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "fluentd"
  gem.add_runtime_dependency "redis"

  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
end
