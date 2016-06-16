require "active_record"

class Reputation < ActiveRecord::Base
  has_many :interactions


  def interactions_type(type)
    interactions
      .where(type_: type)
      .order(created_at: :desc)
  end

  def num_interactions(type)
    interactions_type(type).size
  end

  def media(type)
    total = 0
    interactions =  interactions_type(type)
    if(interactions.empty?)
      return 0
    end
    interactions.each{|i| total += i.evaluation_value.to_i }
    (total / interactions.size)
  end

end
