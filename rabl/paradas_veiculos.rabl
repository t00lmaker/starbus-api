object false
child @paradas, :root => :paradas, :object_root => false do
  attributes :codigo, :denominacao, :endereco, :lat, :long, :dist
  child :reputation do |ele|
    node(:mov){ ele.media('MOVIMENTACAO') }
    node(:est){ ele.media('ESTADO') }
    node(:seg){ ele.media('SEGURANCA') }
    node(:con){ ele.media('CONFORTO') }
    node(:ace){ ele.media('ACESSO') }
  end
  child :linhas, :object_root => false do
    attributes :codigo, :denominacao, :retorno, :origem, :circular
  end
end

child @veiculos, :root => :veiculos, :object_root => false do
  attributes :codigo, :hora, :lat, :long, :last_lat, :last_long
end
