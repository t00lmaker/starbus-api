require 'grape'
require './model/linha'
require './model/parada'
require './model/veiculo'
require './model/reputation'
require './model/interaction'
require './model/checkin'
require './model/token'
require './model/user'
require './lib/load_linhas_paradas'
require './lib/client-strans'
require 'grape-rabl'

module StarBus
  class API < Grape::API
    version 'v1'
    prefix  :api
    format  :json
    formatter :json, Grape::Formatter::Rabl


    before do
      puts headers['Token']
    end

    helpers do
      def current_user
        User.all.first
      end
    end

    resource :linhas do
      params do
        optional :busca, desc: 'termo para busca da linha.'
      end
      desc 'Retornas as linhas registradas, filtradas ou não pelo parâmetro código.'
      get '/', :rabl => "linhas.rabl" do
        busca = params[:busca].upcase
        if(params[:busca])
          puts "%#{busca}%"
          @linhas = Linha.where("codigo = ? OR denominacao like ?", busca, "%#{busca}%")
        else
          @linhas = Linha.all
        end
        #error!({ erro: 'Linha nao registrada', detalhe: 'Verifique o codigo passado por parametro.' }, 404)
      end

      desc 'Recarrega todas as Linhas e salva com base na API Integrah.'
      get :load do
        LoadLinhasParadas.new.init
      end

      params do
        requires :codigo, desc: 'código da parada que deseja as linhas.'
      end
      get 'parada/:codigo', :rabl => "linhas.rabl" do
        parada = Parada.find_by_codigo(params[:codigo])
        if parada
          @linhas = parada.linhas
        else
          error!({ erro: 'Parada nao registrada', detalhe: 'Verifique o codigo passado por parametro.' }, 404)
        end
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
        requires :codigo, desc: 'código da parada que será feito o checkin.'
      end
      post :checkin do
        check_in = Checkin.new
        check_in.user = current_user
        check_in.parada = Parada.find_by_codigo(params[:codigo])
        check_in.save!
      end

      params do
        requires :lat, type:  Float
        requires :long, type: Float
        requires :dist, type: Float
      end
      get :proximas, :rabl => "paradas.rabl" do
        @paradas = StransAPi.instance.paradas_proximas(params[:long], params[:lat], params[:dist])
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

      params do
        requires :codigo, desc: 'código do veículo que será feito o checkin.'
      end
      post :checkin do
        check_in = Checkin.new
        check_in.user = current_user
        check_in.veiculo = Veiculo.find_by_codigo(params[:codigo])
        check_in.save!
      end

    end

    params do
      requires :type, values: ['con','seg','mov','pon','ace','est']
      requires :codigo
      optional :evaluation, values: Interaction.evaluations.values
      optional :comment
    end
    resource :interactions do

      get ':type/parada/:codigo', :rabl => "interactions.rabl" do
        @type = Interaction.type_s[params[:type]]
        parada = Parada.find_by_codigo(params[:codigo])
        @reputation = parada.reputation
        @interactions = @reputation.interactions_type(@type)
      end
      get ':type/veiculo/:codigo', :rabl => "interactions.rabl" do
        @type = Interaction.type_s[params[:type]]
        veiculo = Veiculo.find_by_codigo(params[:codigo])
        @reputation = veiculo.reputation
        @interactions = @reputation.interactions_type(@type)
      end

      post ':type/parada/:codigo' do
        i = Interaction.new
        i.user = current_user
        i.type_ = params[:type]
        i.comment = params[:comment]
        i.evaluation = params[:evaluation]
        parada = Parada.find_by_codigo(params[:codigo])
        parada.reputation ||= Reputation.new
        parada.reputation.interactions << i
        parada.save!
      end
      post ':type/veiculo/:codigo' do
        i = Interaction.new
        i.user = current_user
        i.type_ = params[:type]
        i.comment = params[:comment]
        i.evaluation = params[:evaluation]
        veiculo = Veiculo.find_by_codigo(params[:codigo])
        veiculo.reputation ||= Reputation.new
        veiculo.reputation.interactions << i
        veiculo.save!
      end
    end

  end #class
end #module
