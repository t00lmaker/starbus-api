object false
child @paradas, :root => :paradas, :object_root => false do
  attributes :codigo, :denominacao, :endereco, :lat, :long, :dist
  child :reputation do |ele|
    unless ele.nil?
      node(:mov){ ele.media('MOVIMENTACAO') }
      node(:est){ ele.media('ESTADO') }
      node(:seg){ ele.media('SEGURANCA') }
      node(:con){ ele.media('CONFORTO') }
      node(:ace){ ele.media('ACESSO') }
    end
  end
  child :linhas, :object_root => false do |ele|
    unless ele.nil?
      attributes :codigo, :denominacao
    end
  end
end

child @veiculos, :root => :veiculos, :object_root => false do
  attributes :codigo, :hora, :lat, :long
  child :linha  => :linha do
    attributes :codigo, :denominacao, :retorno, :origem, :circular
  end
end
