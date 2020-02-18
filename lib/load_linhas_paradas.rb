require 'strans-client'
require './model/linha'
require './model/parada'

class LoadLinhasParadas

  def init
    @paradas = {}
    @strans = StransClient.new(ENV['EMAIL'],ENV['PASSWORD'],ENV['KEY'])
    linhas = @strans.get(:linhas)
    if(linhas.is_a?(ErroStrans))
      raise RuntimeError, "Strans Api error '#{linhas.to_json}'"
    else 
      create_linhas(linhas)
    end
  end

  def create_linhas(linhas)
    linhas.each do |l|
      has_linha = Linha.find_by_codigo(l.codigoLinha)
      unless(has_linha)
        linha = transform_in_linhas(l)
        paradas = @strans.get(:paradas_linha, linha.codigo)
        if(paradas.is_a?(ErroStrans))
          puts "Strans Api error '#{paradas.to_json}'"
        else
          paradas = transform_in_paradas(paradas)
          linha.paradas = paradas              
        end
        puts linha.codigo
        linha.save!
      end
    end
  end

  #Transforma um linha do modelo Strans para uma
  #linha do modelo starbus.
  def transform_in_linhas(linha_strans)
    linha_hash = {}
    linha_strans.instance_variables.each do |var|
      attr_name = var.to_s.delete("@")
      attr_name = :codigo if attr_name == 'codigoLinha'
      attr_name = :denominacao if attr_name == 'denomicao'
      linha_hash[attr_name] = linha_strans.instance_variable_get(var)
    end
    linha_hash = linha_hash.except("veiculos")
    linha_hash = linha_hash.except("paradas")
    Linha.new(linha_hash)
  end

  def transform_in_paradas(paradas_strans)
    parada_hash = {}
    paradas = []
    paradas_strans.each do |p|
      p.instance_variables.each do |var|
        attr_name = var.to_s.delete("@")
        attr_name = :codigo if attr_name == 'codigoParada'
        attr_name = :denominacao if attr_name == 'denomicao'
        parada_hash[attr_name] = p.instance_variable_get(var)
      end
      parada_hash = parada_hash.except("linha")
      parada = @paradas[p.codigoParada] || Parada.new(parada_hash)
      @paradas[p.codigoParada] = parada
      parada.reputation ||= Reputation.new
      paradas << parada
    end
    paradas
  end

end
