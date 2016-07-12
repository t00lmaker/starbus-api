collection @veiculos, :root => :veiculos, :object_root => false
attributes :codigo, :hora, :lat, :long, :last_lat, :last_long
child :reputation do |ele|
  node(:mov){ ele.media('MOVIMENTACAO') }
  node(:est){ ele.media('ESTADO') }
  node(:seg){ ele.media('SEGURANCA') }
  node(:con){ ele.media('CONFORTO') }
  node(:ace){ ele.media('ACESSO') }
end
child :linha  => :linha do
  attributes :codigo, :denominacao, :retorno, :origem, :circular
end
