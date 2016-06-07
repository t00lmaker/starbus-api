
collection @paradas, :root => :paradas, :object_root => false
attributes :codigo, :denominacao, :endereco, :lat, :long, :dist
child :linhas, :object_root => false do
    attributes :codigo, :denominacao
end
