# frozen_string_literal: true

collection @stops, root: :stops, object_root: false
attributes :code, :description, :address, :lat, :long, :dist
child :lines, object_root: false do |ele|
  attributes :code, :description, :return, :origin, :circular unless ele.nil?
end
