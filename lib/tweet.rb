class Tweet < ActiveRecord::Base 
  validates_uniqueness_of :twid
end