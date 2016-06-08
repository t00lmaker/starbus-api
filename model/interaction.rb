require "active_record"

class Interaction < ActiveRecord::Base
  belongs_to :reputation
  belongs_to :user

  enum type_: { ace:'ACESSO',
                conf:'CONFORTO',
                est:'ESTADO',
                mov:'MOVIMENTACAO',
                pon:'PONTUALIDADE',
                seg:'SEGURANCA',
              }

  enum evaluation: { pessimo: '1', ruim: '2',regular: '3', bom: '4', otimo: '5' }

  def evaluation_value()
    Interaction.evaluations[self.evaluation]
  end

end
