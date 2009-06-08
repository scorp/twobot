#!/usr/bin/env ruby

# application config
require File.join(File.dirname(__FILE__), '..', 'config', 'web_admin_configuration.rb')

class WebAdmin < Sinatra::Base
  include WebAdminConfiguration
  
  # admin home
  get "/" do
    erb :index
  end
  
  # start the twobot daemon
  get "/start" do
    `#{File.join(APP_ROOT, "bin", "twobot-daemon-control")} start`
    redirect "/"
  end
  
  # stop the twobot daemon
  get "/stop" do
    `#{File.join(APP_ROOT, "bin", "twobot-daemon-control")} stop`
    redirect "/"
  end

  # view a twobot
  get "/twobot/:id" do
    @twobot = Twobot.find(params[:id])
    halt :status => 404 unless @twobot 
    erb :twobot
  end
end

# start it up if we are in dev mode
WebAdmin.run! if WebAdmin.development?