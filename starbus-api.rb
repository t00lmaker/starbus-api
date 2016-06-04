require 'grape'
require './model/linha'
require './model/parada'
require './model/veiculo'
require './model/reputation'
require './model/interaction'
require './lib/load_linhas_paradas'
require './lib/client-strans'
require 'grape-rabl'
require 'pry'

module StarBus
  class API < Grape::API
    version 'v1'
    format  :json, Grape::Formatter::Rabl
    prefix  :api

    before do
      puts headers['Token']
    end

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

      desc 'Recarrega todas as Linhas e salva com base na API Integrah.'
      get :load do
        LoadLinhasParadas.new.init
      end
    end #resource :linha

    resource :paradas do
      params do
        optional :codigo, desc: 'código da linha'
      end
      desc 'Retornas as linhas registradas, filtradas ou não pelo parâmetro código.'
      get '/' do
        if(params[:codigo])
          Parada.find_by_codigo(params[:codigo]) ||
          error!({ erro: 'Parada nao registrada', detalhe: 'Verifique o codigo passado por parametro.' }, 404)
        else
          Parada.all
        end
      end

      params do
        requires :codigo, desc: 'código da parada que será buscada as linhas.'
      end
      desc 'Retornas as paradas registradas, filtradas ou não pelo parâmetro código.'
      get :linhas do
        parada = Parada.find_by_codigo(params[:codigo])
        if parada
          parada.linhas
        else
          error!({ erro: 'Parada nao registrada', detalhe: 'Verifique o codigo passado por parametro.' }, 404)
        end
      end

      params do
        requires :lat, type:  Float
        requires :long, type: Float
        requires :dist, type: Float
      end
      get :proximas do
        StransAPi.instance.paradas_proximas(params[:long], params[:lat], params[:dist])
      end

    end

    resource :veiculos do
      get :agora do
        StransAPi.instance.get(:linhas)
      end
      params do
        requires :codigo, desc: 'código da linha que deseja os veículos.'
      end
      get :linha do
        StransAPi.instance.get(:veiculos_linha, params[:codigo])
      end
    end

    params do
      requires :type, values: ['con','seg','mov','pon','ace','est']
      requires :codigo
      optional :avaliacao
    end
    resource :interactions do

      get ':type/parada/:codigo' do
        parada = Parada.find_by_codigo(params[:codigo])
        parada.reputation.interactions.where(tipo: Interaction.tipos[params[:type]])
      end
      get ':type/veiculo/:codigo' do
        veiculo = Veiculo.find_by_codigo(params[:codigo])
        veiculo.reputation.interactions.where(tipo: Interaction.tipos[params[:type]])
      end

      post ':type/parada/:codigo' do
        i = Interaction.new
        i.tipo = params[:type]
        i.avaliacao = params[:avaliacao]
        veiculo = Parada.find_by_codigo(params[:codigo])
        veiculo.reputation ||= Reputation.new
        veiculo.reputation.interactions << i
      end
      post ':type/veiculo/:codigo' do
        i = Interaction.new
        i.tipo = params[:type]
        i.avaliacao = params[:avaliacao]
        veiculo = Veiculo.find_by_codigo(params[:codigo])
        veiculo.reputation ||= Reputation.new
        veiculo.reputation.interactions << i
      end
    end

  end #class
end #module
