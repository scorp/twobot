class Action < ActiveRecord::Base
  belongs_to :search
  
  def awake
    self.instance_eval(code)
  end

  # to be overridden
  def process
  end

end