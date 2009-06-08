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
  
  # ==========
  # = Twobot =
  # ==========
  # view a twobot
  get "/twobot/:id" do
    @twobot = Twobot.find(params[:id])
    halt :status => 404 unless @twobot 
    erb :twobot
  end

  get "/twobot/:id/activate" do
    @twobot = Twobot.find(params[:id])
    @twobot.update_attributes("status" => "active")
    halt :status => 404 unless @twobot 
    redirect "/"
  end

  get "/twobot/:id/deactivate" do
    @twobot = Twobot.find(params[:id])
    halt :status => 404 unless @twobot 
    @twobot.update_attributes("status" => "inactive")
    redirect "/"
  end

  # ============
  # = Searches =
  # ============
  post "/twobot/:id/searches" do
    @twobot = Twobot.find(params[:id])
    halt :status => 404 unless @twobot 
    search = @twobot.searches.create({
      :query => params[:query]
    })
    search.actions.create({:code => params[:code]})
    redirect "/twobot/#{@twobot.id}"
  end
  
  get "/twobot/:id/searches/:search_id/destroy" do
    @twobot = Twobot.find(params[:id])
    @twobot.searches.find_by_id(params[:search_id]).destroy
    redirect "/twobot/#{@twobot.id}"
  end
  
  get "/twobot/:id/searches/:search_id/view" do
    @twobot = Twobot.find(params[:id])
    @search = @twobot.searches.find_by_id(params[:search_id])
    erb :search
  end
  
  # ===========
  # = Actions =
  # ===========
  # create an action
  post "/twobot/:id/searches/:search_id/actions" do
    @twobot = Twobot.find(params[:id])
    @search = @twobot.searches.find_by_id(params[:search_id])
    @search.actions.create(:code=>params[:code])
    redirect "/twobot/#{params[:id]}/searches/#{params[:search_id]}/view"
  end

  # remove an action
  get "/twobot/:id/searches/:search_id/actions/:action_id/destroy" do
    @twobot = Twobot.find(params[:id])
    @search = @twobot.searches.find_by_id(params[:search_id])
    @action = @search.actions.find(params[:action_id])
    @action.destroy
    redirect "/twobot/#{params[:id]}/searches/#{params[:search_id]}/view"
  end
  
  # update an action
  post "/twobot/:id/searches/:search_id/actions/:action_id" do
    @twobot = Twobot.find(params[:id])
    @search = @twobot.searches.find_by_id(params[:search_id])
    @action = @search.actions.find(params[:action_id])
    @action.update_attributes(:code=>params[:code])
    redirect "/twobot/#{params[:id]}/searches/#{params[:search_id]}/view"
  end
end


# start it up if we are in dev mode
WebAdmin.run! if WebAdmin.development?