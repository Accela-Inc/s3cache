#encoding: utf-8
require File.expand_path('../lib/s3cache.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 's3cache'
  gem.version     = S3Cache::VERSION
  gem.description = %q(A simple caching library that serializes objects to the filesystem and is compatible with the Rails.cache API)
  gem.summary     = gem.description
  
  gem.files       = `git ls-files`.split("\n")
  gem.require_paths = ['lib']  
  gem.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  # gem.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.homepage    = "https://github.com/eddietejeda/s3cache"

  gem.license     = 'BSD-3-Clause'
  gem.authors     = ['Eddie A Tejeda']
  gem.email       = ['eddie@codeforamerica.org']

  gem.add_development_dependency 'rake','~> 13'
  gem.add_development_dependency 'rspec','~> 3.x'
  gem.add_development_dependency 'aws-sdk','~> 2'
end

