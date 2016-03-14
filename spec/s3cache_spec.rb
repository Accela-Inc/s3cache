# I can't figure out how to test s3 modules without requiring a bunch of new gems.
# Should look into fake-s3 gem

# require 'spec_helper'
require_relative '../lib/s3cache'

describe S3Cache do

  before do
    # AWS.stub!
    # @s3cache = S3Cache.new({:bucket_name => 'test-s3-cache'})
    # @cache_name = ['spec', 'test']
    # @cached_contents = 'Hello World'
  end

  describe "test methods" do
    
    it "S3Cache#write should save serialized object to tmp" do
      # @s3cache.write(@cache_name, @cached_contents)
      # expect(@s3cache.exist?(@cache_name)).to be_truthy
    end

    it "S3Cache#read should be able to read serialized objects" do
      # @s3cache.read(@cache_name).eql?( @cached_contents)
    end
    
    it "S3Cache#fetch should be able to read serialized objects" do
      # cache_name_fetch = "#{@cache_name}-fetch"
      # cache_contents_fetch = "Hello World Fetch"
      #
      # response = @s3cache.fetch( cache_name_fetch) do
      #   cache_contents_fetch
      # end
      #
      # cache_name_fetch.eql?( response)
      # @s3cache.read(cache_name_fetch).eql?( response)
    end

    it "S3Cache#clear should clear cache" do
      # @s3cache.clear
      # expect(@s3cache.exist?(@cache_name)).to be_falsey
    end

  end
end