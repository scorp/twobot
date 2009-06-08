# =========================
# = Database connectivity =
# =========================
class DB
  cattr_reader :connection
  
  # CLASS METHODS
  class << self
    # create the database connection
    def setup_connection
      config = ERB.new(File.read(File.join(APP_ROOT, "config", "database.yml"))).result
      ActiveRecord::Base.establish_connection(YAML.load(config))
      DB.prepare_schema unless schema_prepared?
    end
    
    def schema_prepared?
      IO.popen("sqlite3 db .tables").read.split.include?("twobots")
    end
  
    # build out the schema
    def prepare_schema
      
      ActiveRecord::Schema.define do
        # a twobot instance
        create_table  :twobots do |t|
          t.string    :name
        end
        add_index :twobots, :name
        
        # has many twitter searches
        create_table :searches do |t|
          t.integer   :twobot_id,        :null => false
          t.string    :query,            :null => false
          t.integer   :last_twid,        :null => false,   :default => 0
          t.timestamp :last_run
          t.integer   :last_result_count
        end
        add_index :searches, :query
        
        # a search has many actions
        create_table  :actions do |t|
          t.integer   :search_id,        :null => false
          t.text      :code
        end
        
        # cache of tweets
        create_table :tweets do |t|
          t.integer   :twid,                :null => false
          t.string    :from_user
          t.string    :to_user
          t.integer   :from_user_id
          t.integer   :to_user_id
          t.string    :text
          t.string    :profile_image_url
          t.timestamp :created_at
        end
        add_index :tweets, :twid
      end
      
    end

  end
end
DB.setup_connection