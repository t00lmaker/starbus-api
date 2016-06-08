collection @veiculos, :root => :veiculos, :object_root => false
attributes :codigo, :hora, :lat, :long
child :linha   => :linha do
  attributes :codigo, :denominacao, :retorno, :origem, :circular
end
