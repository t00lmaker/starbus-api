# frozen_string_literal: true

object false
child @stops, root: :stops, object_root: false do
  attributes  :code, :description, :address, :lat, :long, :dist
end

child @vehicles, root: :vehicles, object_root: false do
  attributes :code, :hora, :lat, :long, :last_lat, :last_long
end
