require "active_record"

class Interaction < ActiveRecord::Base
  belongs_to :reputation

  enum tipo: {  ace:'ACESSO',
                conf:'CONFORTO',
                est:'ESTADO',
                mov:'MOVIMENTACAO',
                pon:'PONTUALIDADE',
                seg:'SEGURANCA',
              }

  enum avaliacao: { pessimo:1, ruim:2,
                    regular:3, bom: 4, otimo: 5 }





end
