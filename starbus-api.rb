require 'grape'
require './model/linha'
require './model/parada'
require './model/veiculo'
require './model/reputation'
require './model/interaction'
require './model/checkin'
require './model/token'
require './model/user'
require './model/sugestion'
require './model/result'
require './lib/load_linhas_paradas'
require './lib/load_veiculos'
require './lib/client-strans'
require './lib/bus-cache'
require './lib/face-control'
require 'grape-rabl'

I18n.config.available_locales = :en

module StarBus
  class API < Grape::API
    version 'v1'
    format  :json
    formatter :json, Grape::Formatter::Rabl

    before do
      #puts headers['User-id']
      #puts headers['Token']
    end

    helpers do
      def current_user
        User.all.first
      end
    end

    resource :user do
      params do
        requires :user, desc: 'Código identificador do facebook do usuário.'
        requires :hash, desc: 'hash de autenticação facebook.'
        optional :name, desc: 'Nome do usuario.'
        optional :email, desc: 'E-mail do usuario.'
        optional :url_photo, desc: 'E-mail do usuario.'
        optional :url_face, desc: 'Nome do usuario.'
      end
      post :login do
        hash = FaceControl.instance.auth(params)
        { "hash" => hash}
      end

      params do
        optional :user, desc: 'Código identificador do facebook do usuário.'
        optional :email, desc: 'E-mail do usuario.'
        requires :text, desc: 'Texto da susgestão'
      end
      post :sugestion do
        if(params[:user])
          @user = User.find_by_id_facebook(params[:hash]) if params[:user]
        elsif(params[:email])
          @user = User.find_by_email(params[:email])
          @user = User.create(email: params[:email]) unless @user
        end
        Sugestion.create(user: @user, text: params[:text]) != nil
      end
    end

    resource :linhas do
      params do
        optional :busca, desc: 'termo para busca da linha.'
      end
      desc 'Retornas as linhas registradas, filtradas ou não pelo parâmetro código.'
      get '/', :rabl => "linhas.rabl" do
        busca = params[:busca]
        if(busca)
          puts busca
          sql = "codigo like ? OR denominacao like ? OR retorno like ?"
          busca = ActiveSupport::Inflector.transliterate(busca)
          busca = busca.upcase
          split = busca.split
          @linhas = Set.new
          split.each do |termo|
            if(termo.size > 2)
              puts "> #{ termo }"
              @linhas = @linhas + Linha
                          .where(sql, "%#{termo}%", "%#{termo}%","%#{termo}%")
                          .order("codigo asc")
            end
          end
        else
          @linhas = Linha.order(:codigo)
        end
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
          @linhas = parada.linhas.order('codigo ASC')
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
      get '/', :rabl => "paradas.rabl"  do
        if(params[:codigo])
          @paradas = Parada.find_by_codigo(params[:codigo]) ||
          error!({ erro: 'Parada nao registrada', detalhe: 'Verifique o codigo passado por parametro.' }, 404)
        else
          @paradas = Parada.all
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
        if(!@paradas || @paradas.empty?)
          @paradas = StransAPi.instance.paradas_proximas(params[:long], params[:lat], (params[:dist] * 2))
        end
      end

    end

    resource :veiculos do

      get :agora, :rabl => "veiculos.rabl" do
        @veiculos = BusCache.instance.all
      end

      get :load do
        LoadVeiculos.new.init
      end

      params do
        requires :codigo, desc: 'código do veciculo.'
      end
      get "/:codigo", :rabl => "veiculo.rabl" do
        @veiculo = BusCache.instance.get(params[:codigo])
        if(!@veiculo)
          error!({ erro: 'Veiculo não encontrado', detalhe: 'Apenas veiculos rodando encontram-se disponiveis aqui.' }, 404)
        end
      end

      params do
        requires :codigo, desc: 'código da linha que deseja os veículos.'
      end
      get "linha/:codigo", :rabl => "veiculos.rabl" do
        @veiculos = BusCache.instance.get_by_line(params[:codigo])
      end

      params do
        requires :codigo, desc: 'código do veículo que será feito o checkin.'
      end
      post :checkin do
        veiculo = BusCache.instance.get(params[:codigo])
        if(veiculo)
          check_in = Checkin.new
          check_in.user = current_user
          check_in.veiculo = veiculo
          return check_in.save!
        end
        error!({ erro: 'Veiculo não encontrado', detalhe: 'Não podemos fazer login em um veiculo que não se encontra rodando.' }, 404)
      end

    end

    params do
      requires :type, values: ['con','seg','mov','pon','ace','est']
      requires :codigo
    end
    resource :interaction do
      get ':type/parada/:codigo', :rabl => "interactions.rabl" do
        @type = Interaction.type_s[params[:type]]
        parada = Parada.find_by_codigo(params[:codigo])
        error!({ erro: 'Parada não encontrada', detalhe: 'Verifique o codigo passado por parametro.' }, 404) if !parada
        @reputation = parada.reputation
        @interactions = @reputation.interactions_type(@type)
      end
      get ':type/veiculo/:codigo', :rabl => "interactions.rabl" do
        codigo = params[:codigo]
        @type = Interaction.type_s[params[:type]]
        veiculo = Veiculo.find_by_codigo(codigo)
        error!({ erro: 'Veiculo não encontrado', detalhe: 'Verifique o codigo passado por parametro.' }, 404) if !veiculo
        @reputation = veiculo.reputation
        @interactions = @reputation.interactions_type(@type)
      end

      params do
        requires :evaluation, values: Interaction.evaluations.values
        requires :comment
        requires :id_facebook
      end
      post ':type/parada/:codigo',:rabl => "result.rabl" do
        i = Interaction.new
        i.user = User.find_by_id_facebook(params[:id_facebook])
        i.type_ = params[:type]
        i.comment = params[:comment]
        i.evaluation = params[:evaluation]
        @result = Result.new
        parada = Parada.find_by_codigo(params[:codigo])
        if(parada)
          parada.reputation ||= Reputation.new
          parada.reputation.interactions << i
          @result.status = parada.save! ? "sucess" : "error"
        else
          @result.status = "error"
          @result.mensage = "Parada não encontrada."
        end
      end

      params do
        requires :evaluation, values: Interaction.evaluations.values
        requires :comment
        requires :id_facebook
      end
      post ':type/veiculo/:codigo', :rabl => "result.rabl" do
        i = Interaction.new
        i.user = User.find_by_id_facebook(params[:id_facebook])
        i.type_ = params[:type]
        i.comment = params[:comment]
        i.evaluation = params[:evaluation]
        @result = Result.new
        veiculo = Veiculo.find_by_codigo(params[:codigo])
        if(veiculo)
          veiculo.reputation ||= Reputation.new
          veiculo.reputation.interactions << i
          @result.status = veiculo.save! ? "sucess" : "error"
        else
          @result.mensage = "Veiculo não encontrado."
        end
       end
    end

    # limite de interacitions por tela.
    #LIMIT = 10
    params do
      requires :type, values: ['con','seg','mov','pon','ace','est']
      requires :codigo
    end
    resource :interactions do

      get ':type/parada/:codigo', :rabl => "interactions.rabl" do
        @type = Interaction.type_s[params[:type]]
        parada = Parada.find_by_codigo(params[:codigo])
        error!({ erro: 'Parada não encontrada', detalhe: 'Verifique o codigo passado por parametro.' }, 404) if !parada
        @reputation = parada.reputation
        @interactions = @reputation.interactions_type(@type)
      end

      get ':type/veiculo/:codigo', :rabl => "interactions.rabl" do
        codigo = params[:codigo]
        @type = Interaction.type_s[params[:type]]
        veiculo = Veiculo.find_by_codigo(codigo)
        error!({ erro: 'Veiculo não encontrado', detalhe: 'Verifique o codigo passado por parametro.' }, 404) if !veiculo
        @reputation = veiculo.reputation
        @interactions = @reputation.interactions_type(@type)
      end

      params do
        requires :evaluation, values: Interaction.evaluations.values
        requires :comment
        requires :id_facebook
      end
      post ':type/parada/:codigo' do
        i = Interaction.new
        i.user = User.find_by_id_facebook(params[:id_facebook])
        i.type_ = params[:type]
        i.comment = params[:comment]
        i.evaluation = params[:evaluation]
        parada = Parada.find_by_codigo(params[:codigo])
        parada.reputation ||= Reputation.new
        parada.reputation.interactions << i
        parada.save!
      end

      params do
        requires :evaluation, values: Interaction.evaluations.values
        requires :comment
      end
      post ':type/veiculo/:codigo' do
        i = Interaction.new
        i.user = User.find_by_id_facebook(params[:id_facebook])
        i.type_ = params[:type]
        i.comment = params[:comment]
        i.evaluation = params[:evaluation]
        veiculo = Veiculo.find_by_codigo(params[:codigo])
        error!({ erro: 'Veiculo não encontrado', detalhe: 'Verifique o codigo passado por parametro.' }, 404) if !veiculo
        veiculo.reputation ||= Reputation.new
        veiculo.reputation.interactions << i
        veiculo.save!
      end
   end

    RAIO_BUSCA_APP = 500

    params do
      requires :lat, type:  Float
      requires :long, type: Float
      requires :codigo
    end
    resource :paradasveiculos do
      get "linha/:codigo", :rabl => "paradas_veiculos.rabl" do
        @linha = Linha.find_by_codigo(params[:codigo])
        if(@linha)
          lon = params[:long]
          lat = params[:lat]
          @paradas = StransAPi.instance.paradas_proximas(lon, lat, RAIO_BUSCA_APP, @linha.paradas)
          if(!@paradas || @paradas.empty?)
            @paradas = StransAPi.instance.paradas_proximas(lon, lat, (RAIO_BUSCA_APP * 2), @linha.paradas)
          end
          @veiculos = BusCache.instance.get_by_line(params[:codigo])
          return
        end
        error!({ erro: 'Linha nao encontrada', detalhe: 'Verifique o codigo da linha passado por parametro.' }, 404)
      end
    end

  end #class
end #module
