require "active_record"

class Reputation < ActiveRecord::Base
  has_many :interactions

  def interactions_type(type, limit = nil)
    interactions
      .where(type_: type)
      .order(created_at: :desc)
      .limit(limit)
  end

  def num_interactions(type)
    ints = interactions_type(type)
    ints ? ints.size : 0
  end

  def media(type)
    total = 0
    avg = 0
    ints = interactions_type(type)
    if(ints && !ints.empty?)
      ints.each{|i| total += i.evaluation_value.to_i }
      avg = (total / ints.size)
    end
    avg
  end

end
