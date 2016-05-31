require 'grape'
require 'strans-client'
require './model/linha'
require './model/parada'
require './lib/load_linhas_paradas'


module StarBus
  class API < Grape::API
    version 'v1'
    format  :json
    prefix  :api

    resource :linhas do

      params do
        optional :codigo, desc: 'código da linha'
      end
      desc 'Retornas as linhas registradas, filtradas ou não pelo parâmetro código.'
      get '/' do
        if(params[:codigo])
          Linha.find_by_codigo(params[:codigo]) ||
          error!({ erro: 'Linha nao registrada', detalhe: 'Verifique o codigo passado por parametro.' }, 404)
        else
          Linha.all
        end
      end

      params do
        requires :codigo, desc: 'código da parada que será buscada as linhas.'
      end
      desc 'Retornas as paradas registradas, filtradas ou não pelo parâmetro código.'
      get :paradas do
        parada = Parada.find_by_codigo(params[:codigo])
        if parada
          parada.linhas
        else
          error!({ erro: 'Parada nao registrada', detalhe: 'Verifique o codigo passado por parametro.' }, 404)
        end
      end



      desc 'Recarrega todas as Linhas e salva com base na API Integrah.'
      get :load do
        LoadLinhasParadas.new.init
      end
    end #resource :linha

  end #class
end #module
