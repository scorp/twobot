class Search < ActiveRecord::Base
  belongs_to :twobot
  has_many :actions, :dependent => :destroy
  
  # use a backoff algorithm to hit less popular terms less frequently
  def execute_when_ready
    execute
  end
  
  # execute the search and run its actions
  def execute
    results = []
    page = 1
    loop do
      new_results = []
      new_results = fetch_page(page).select{ |result| result.id > last_twid}
      puts "got #{new_results.size} new results for page #{page}"
      break unless new_results.size > 0
      results.concat(new_results)
      page += 1
    end 
    results.sort_by{|r|r.id}

    record_results(results)

    run_actions(results)

    self.update_attributes(
      :last_run           =>  Time.now, 
      :last_result_count  =>  results.size, 
      :last_twid          =>  results.size > 0 ? results.first.id : last_twid,
      :total              =>  total + results.size
    )
  end
  
  def run_actions(results)
    results = results.reverse
    actions.each {|action| 
      action.awake
      results.each{|result|
        begin
          action.process(result)
        rescue
          Util.log_error($!, "error encountered with action #{action.id}")
        end
      }
    }
  end
  
  def record_results(results)
    require 'ruby-debug'
    # DB_MUTEX.synchronize do 
      results.each {|result|
        Tweet.create({
          :twid               => result.id,
          :from_user          => result.from_user,
          :to_user            => result.to_user,
          :from_user_id       => result.from_user_id,
          :to_user_id         => result.to_user_id,
          :text               => result.text,
          :profile_image_url  => result.profile_image_url,
          :created_at         => result.created_at
        })
      }
    # end
  end
  
  def fetch_page(page)
    @client ||= Grackle::Client.new(:api=>:search)
    @client.search.json?(:q=>query, :since_id=>last_twid, :rpp=>100, :page=>page).results
  end

end