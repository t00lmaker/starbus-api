# frozen_string_literal: true

collection @stops, root: :stops, object_root: false
attributes :code, :description, :address, :lat, :long, :dist
child :reputation do |ele|
  node(:state) { ele.media('ESTADO') }
  node(:safety) { ele.media('SEGURANCA') }
  node(:comfort) { ele.media('CONFORTO') }
  node(:accessibility) { ele.media('ACESSO') }
end
child :lines, object_root: false do |ele|
  attributes :code, :description, :return, :origin, :circular unless ele.nil?
end
