# frozen_string_literal: true

require "active_record"

class Interaction < ActiveRecord::Base
  belongs_to :reputation
  belongs_to :user

  enum type_: { accessibility: "ACESSIBILITY",
                comfort: "COMFORT",
                state: "STATE",
                environment: "ENVIRONMENT",
                time: "TIMER",
                safety: "SAFETY",
                driver: "DRIVER",
                frequency: "FREQUENCY" }

  enum evaluation: { terrible: "1",
                     bad: "2",
                     regular: "3",
                     good: "4",
                     great: "5" }

  def evaluation_value
    Interaction.evaluations[evaluation]
  end
end
