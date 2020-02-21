collection @stops, :root => :stops, :object_root => false
attributes :code, :denominacao, :endereco, :lat, :long, :dist
child :reputation do |ele|
  node(:mov){ ele.media('MOVIMENTACAO') }
  node(:est){ ele.media('ESTADO') }
  node(:seg){ ele.media('SEGURANCA') }
  node(:con){ ele.media('CONFORTO') }
  node(:ace){ ele.media('ACESSO') }
end
child :lines, :object_root => false do |ele|
  unless ele.nil?
    attributes :code, :denominacao, :retorno, :origem, :circular
  end
end
