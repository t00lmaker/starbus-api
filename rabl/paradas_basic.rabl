collection @paradas, :root => :paradas, :object_root => false
attributes :codigo, :denominacao, :endereco, :lat, :long, :distx
child :linhas, :object_root => false do |ele|
  unless ele.nil?
    attributes :codigo, :denominacao, :retorno, :origem, :circular
  end
end
