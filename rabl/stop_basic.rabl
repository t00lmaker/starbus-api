collection @stops, :root => :stops, :object_root => false
attributes :code, :denominacao, :endereco, :lat, :long, :distx
child :lines, :object_root => false do |ele|
  unless ele.nil?
    attributes :code, :denominacao, :retorno, :origem, :circular
  end
end
