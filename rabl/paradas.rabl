collection @paradas, :root => :paradas, :object_root => false
attributes :codigo, :denominacao, :endereco, :lat, :long, :dist
child :reputation do |ele|
  node(:ace){ ele.media('MOVIMENTACAO') }
  node(:est){ ele.media('ESTADO') }
  node(:seg){ ele.media('SEGURANCA') }
  node(:con){ ele.media('CONFORTO') }
  node(:mov){ ele.media('CONFORTO') }
end
child :linhas, :object_root => false do
    attributes :codigo, :denominacao
end
