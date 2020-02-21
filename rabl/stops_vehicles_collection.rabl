object false
child @stops, :root => :stops, :object_root => false do
  attributes :code, :denominacao, :endereco, :lat, :long, :dist
end

child @vehicles, :root => :vehicles, :object_root => false do
  attributes :code, :hora, :lat, :long, :last_lat, :last_long
end
