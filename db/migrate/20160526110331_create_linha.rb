class CreateLinha < ActiveRecord::Migration
  def self.up
    # :codigoLinha, :denominacao, :origem,
    #  :retorno, :circular, :veiculos, :paradas

    create_table :linhas do |t|
      t.string :codigo
      t.string :denominacao
      t.string :retorno
      t.string :origem
      t.boolean :circular
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :linhas
  end
end
