require File.join(File.dirname(__FILE__), '..', 'lib', 'boot.rb')
require 'sinatra/base'

module WebConfiguration
  
  def self.included(i)
    i.extend(ApplicationConfiguration::ClassMethods)
    i.load
  end
  
  module ClassMethods
    def load
      puts "loading configuration"
      
      # configure the push app
      set :root, File.dirname(__FILE__) + "/../"
      set :port, 8550
      set :run, false
      
      puts "running in env:#{environment} on #{port}"

      # logging
      set :logging, true
      set :dump_errors, true
      
      # db config
      set :db_yaml, YAML.load_file(File.join(root, "config", "database.yml"))
      set :db_config, db_yaml[environment] || db_yaml[:defaults]
      set :db, PushDB.new

      # session
      set :session_key_yaml, YAML.load_file(File.join(root, "config", "session_key.yml"))
      set :session_secret, session_key_yaml[environment] ? session_key_yaml[environment][:secret] : session_key_yaml[:defaults][:secret]

      # memcached
      set :memcached_yaml, YAML.load_file(File.join(root, "config", "memcached.yml"))
      set :memcached_config, memcached_yaml[environment] || memcached_yaml[:defaults]
      set :cache, Memcached.new(memcached_config[:servers], :namespace => memcached_config[:namespace])

      #misc stats
      set :started_at, Time.now
      set :poll_requests, 0
    end
  end
end