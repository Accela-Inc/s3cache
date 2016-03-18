#S3Cache
A simple caching library that serializes objects to the filesystem and is compatible with the Rails.cache API

#Installation
    gem install s3cache

Or add the following to your Gemfile (do this for now):
    
    gem 's3cache', :git => 'git://github.com/eddietejeda/s3cache.git'

#Usage examples

    require 's3cache'
    cache = S3Cache.new({:bucket_name => "aws-bucket-name"})

    cache.write("cache_name", "cache_contents")

    contents = filecache.read("cache_name")

    filecache.fetch("cache_name") do
        "cache_contents"
    end