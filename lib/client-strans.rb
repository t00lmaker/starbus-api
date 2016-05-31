
require "singleton"
require "lazy-strans-client"


#Simples Singleton para garantir
# que a validação do token está funcionando,
# pois a api já faz o gerenciamento do Token.
class StrabsAPi
  include Singleton

  def initialize
    @client = StransClient.new(ENV['email'],ENV['senha'],ENV['key'])
  end

  # Chamdadas aos servicos padroes da API
  def get(path, busca=nil)
    @client.get(path, busca)
  end

  # retorna todas as Paradas próximas a as coordenadas passadas.
  def paradas_proximas(long, lat, dist)
    paradas = []
    Parada.all.each do |parada|
      if(!parada.long.nil? && !parada.long.nil?)
        dLong = calc_distan(long, parada.long)
        dLat  = calc_distan(lat, parada.lat)

        #mutiplicacao do sen da metade da distancia da Lat;
        msmdl = Math::sin(dLat/2) * Math::sin(dLat/2)
        #mutiplicaçao cos da Latitude * PI
        mclPI = Math::cos(lat * Math::PI / 180) * Math::cos(parada.lat * Math::PI / 180)
        #mutiplicacao da metade do seno
        mmds = Math::sin(dLong/2) * Math::sin(dLong/2)
        a = msmdl + mclPI * mmds

        c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
        d = RAIO_TERRA * c
        dist_parada = d * 1000 # distancia em metros

        if(dist_parada < dist)
          parada.dist = dist_parada # metros
          paradas << parada
        end
      end
    end
    paradas
  end

  private

  # Calcula da diferenca entre duas lats ou longs.
  def calc_distan(pos1, pos2)
    (pos1 - pos2) * Math::PI / 180
  end


end
