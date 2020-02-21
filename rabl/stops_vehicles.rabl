object false
child @stops, :root => :stops, :object_root => false do
  attributes :code, :denominacao, :endereco, :lat, :long, :dist
  child :reputation do |ele|
    node(:mov){ ele.media('MOVIMENTACAO') }
    node(:est){ ele.media('ESTADO') }
    node(:seg){ ele.media('SEGURANCA') }
    node(:con){ ele.media('CONFORTO') }
    node(:ace){ ele.media('ACESSO') }
  end
  child :lines, :object_root => false do
    attributes :code, :denominacao, :retorno, :origem, :circular
  end
end

child @vehicles, :root => :vehicles, :object_root => false do
  attributes :code, :hora, :lat, :long, :last_lat, :last_long
end
