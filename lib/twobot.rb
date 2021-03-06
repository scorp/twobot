# =================
# = Twitter Robot =
# =================
#       *     
#       |     
#  _____|___  
# |   \   / | 
# |  ()   ()| - twobot
# | ########| 
# ------------
#
class Twobot < ActiveRecord::Base
  has_many :searches, :dependent => :destroy
  has_many :actions, :dependent => :destroy
  
  # add a search term and action
  def add_search_action(options)
    search = searches.find_or_create_by_query(options[:query])
    search.actions.create({:code=>options[:code]})
  end
  
  # execute a search and run any related actions
  def twake_twaction
    # threads = []
    searches.all.each{|search| 
      # threads << Thread.new do
        puts "running:#{search.query}"
        search.execute_when_ready
      # end
    }
    # threads.each{|thread|thread.join}
  end

end