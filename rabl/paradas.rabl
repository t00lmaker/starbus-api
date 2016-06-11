collection @paradas, :root => :paradas, :object_root => false
attributes :codigo, :denominacao, :endereco, :lat, :long, :dist
child :reputation do |ele|
  node(:mov){ ele.media('MOVIMENTACAO') }
  node(:est){ ele.media('ESTADO') }
  node(:seg){ ele.media('SEGURANCA') }
  node(:con){ ele.media('CONFORTO') }
  node(:ace){ ele.media('ACESSO') }
end
child :linhas, :object_root => false do |ele|
  unless ele.nil?
    attributes :codigo, :denominacao
  end
end
