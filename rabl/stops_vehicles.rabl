object false
child @stops, :root => :stops, :object_root => false do
  attributes  :code, :description, :address, :lat, :long, :dist
  child :reputation do |ele|
    node(:state) { ele.media('ESTADO') }
    node(:safety) { ele.media('SEGURANCA') }
    node(:comfort) { ele.media('CONFORTO') }
    node(:accessibility) { ele.media('ACESSO') }
  end
  child :lines, :object_root => false do
    attributes :code, :description, :return, :origin, :circular
  end
end

child @vehicles, :root => :vehicles, :object_root => false do
  attributes :code, :time, :lat, :long, :last_lat, :last_long
end
