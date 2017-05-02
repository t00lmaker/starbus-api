object false
child @paradas, :root => :paradas, :object_root => false do
  attributes :codigo, :denominacao, :endereco, :lat, :long, :dist
end

child @veiculos, :root => :veiculos, :object_root => false do
  attributes :codigo, :hora, :lat, :long, :last_lat, :last_long
end
