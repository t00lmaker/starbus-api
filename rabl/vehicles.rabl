collection @vehicles, :root => :vehicles, :object_root => false
attributes :code, :hora, :lat, :long, :last_lat, :last_long
child :reputation do |ele|
  node(:mov){ ele.media('MOVIMENTACAO') }
  node(:est){ ele.media('ESTADO') }
  node(:seg){ ele.media('SEGURANCA') }
  node(:con){ ele.media('CONFORTO') }
  node(:ace){ ele.media('ACESSO') }
end
child :line  => :line do
  attributes :code, :denominacao, :retorno, :origem, :circular
end
