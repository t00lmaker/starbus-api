
collection @paradas, :object_root => false
attributes :codigo, :denominacao, :endereco, :lat, :long, :dist
child :reputation, :object_root => false do
  attributes :tipo, :avaliacao
end
child :linhas, :object_root => false do
  attributes :codigo, :denominacao
end
