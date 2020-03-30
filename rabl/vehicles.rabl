# frozen_string_literal: true

collection @vehicles, root: :vehicles, object_root: false
attributes :code, :time, :lat, :long, :last_lat, :last_long
child :reputation do |ele|
  node(:time) { ele.media('HORARIO') }
  node(:state) { ele.media('ESTADO') }
  node(:safety) { ele.media('SEGURANCA') }
  node(:comfort) { ele.media('CONFORTO') }
  node(:accessibility) { ele.media('ACESSIBILIDADE') }
end
child line: :line do
  attributes :code, :description, :return, :origin, :circular
end
