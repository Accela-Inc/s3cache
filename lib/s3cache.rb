require 'digest'
require 'fileutils'
require 'pathname'
require 'yaml'

class S3Cache

  VERSION = "0.9.0"

  def initialize(**params)

    if not params.to_h[:bucket_name]
      puts "requires {:bucket_name => String, (optional) :expires => Integer, (optional) :debug => Boolean }"
    end

    @bucket_name = params.to_h[:bucket_name]
    @expires = params.to_h[:expires] ? params.to_h[:expires] : 32.days
    @debug = params.to_h[:debug] ? params.to_h[:debug] : false
    
    if ENV['AWS_ACCESS_KEY_ID'].nil? || ENV['AWS_SECRET_ACCESS_KEY'].nil?
      puts 'Enviroment variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY must be defined. Learn more http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#config-settings-and-precedence'  
    else
      @s3 = Aws::S3::Client.new
      if not bucket_exist?
        puts "creating bucket #{@bucket_name}" if @debug
        bucket_create
      end
    end
  end

  def read(key, **params)
    key_name = cache_key( key )
    puts "read #{key_name}" if @debug
    if exist?(key_name)
      Marshal.load(@s3.get_object({ bucket: @bucket_name, key: key_name }).body.read)
    else
      return false
    end    
  end

  def write(key, contents, **params) 
    key_name = cache_key( key )
    puts "write #{key_name}" if @debug
    @s3.put_object({ 
      bucket: @bucket_name, 
      key: key_name, 
      expires: Time.now + @expires.days,
      body: Marshal.dump(contents),
    })
  end

  def fetch(key, **params)
    key_name = cache_key( key )

    if(exist?(key_name) )
      puts "fetch->read #{key_name}" if @debug
      read (key_name)
    else
      puts "fetch->write #{key_name}" if @debug
      value = yield
      write(key_name, value)  
      read (key_name)    
    end    
  end

  def exist?(key)   
    key_name = cache_key( key )
    begin
      response =  @s3.get_object({:bucket => @bucket_name, :key => key_name})
    rescue 
      response = nil
    end
    puts "exists? #{response} #{key_name}" if @debug
    return !response.nil?
  end
  
  def clear
    cache_keys.each do |key|
      puts "deleting key #{key}" if @debug
      @s3.delete_object({:bucket => @bucket_name, :key => key})
    end
  end  

  # --------- private --------- 
  private

    def cache_keys
      @s3.list_objects({:bucket => @bucket_name}).first[:contents].collect{|e|e.key}
    end

    def cache_valid(key)
      exist?(key)
    end

    def cache_key(key)      
      if(key.is_a?(String) && key.downcase.match(/^[a-f0-9]{64}$/) )
        key
      else
        Digest::SHA256.hexdigest(key.to_s).to_s        
      end      
    end
    
    def bucket_create
      @s3.create_bucket({
        acl: "private", # accepts private, public-read, public-read-write, authenticated-read
        bucket: @bucket_name, # required
      })      
    end
    
    def bucket_exist?
      begin
        response = @s3.head_bucket({ bucket: @bucket_name })
      rescue 
        response = nil
      end
      return !response.nil?
    end   
end

