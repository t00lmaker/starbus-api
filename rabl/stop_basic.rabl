collection @stops, :root => :stops, :object_root => false
attributes  :code, :description, :address, :lat, :long, :dist
child :lines, :object_root => false do |ele|
  unless ele.nil?
    attributes :code, :description, :return, :origin, :circular
  end
end
