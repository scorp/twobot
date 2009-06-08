require File.join(File.dirname(__FILE__), '..', 'lib', 'boot.rb')
require 'sinatra/base'

module WebAdminConfiguration
  
  def self.included(i)
    i.extend(WebAdminConfiguration::ClassMethods)
    i.load
  end
  
  module ClassMethods
    def load
      puts "loading configuration"
      
      # configure the push app
      set :root, File.dirname(__FILE__) + "/../"
      set :port, 8880
      set :run, false
      
      puts "running in env:#{environment} on #{port}"

      # logging
      set :logging, true
      set :dump_errors, true
    end
  end
end