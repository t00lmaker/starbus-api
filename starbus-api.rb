require 'grape'
require './model/line'
require './model/stop'
require './model/vehicle'
require './model/reputation'
require './model/interaction'
require './model/checkin'
require './model/token'
require './model/user'
require './model/sugestion'
require './model/result'
require './lib/load_lines_stops'
require './lib/load_vehicles'
require './lib/client_strans'
require './lib/bus_cache'
require './lib/face_control'
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

    resource :aplicacoes do
      params do
      end
      post '/' do
      
      end
      
      get '/' do
      
      end
      
      params do
        requires :id, desc: 'id da aplicacão para retorno dos dados.'
      end
      get '/:id' do 
      
      end
      
      params do
        requires :id, desc: 'id da aplicacão que deseja atualizar.'
      end
      put '/:id' do 
      
      end

      params do
        requires :id, desc: 'id da aplicacão que deseja atualizar.'
      end
      delete '/:id' do 
      
      end
    end
    
    resource :users do
      params do
        requires :user, desc: 'Código identificador do facebook do usuário.'
        requires :hash, desc: 'hash de autenticação facebook.'
        optional :name, desc: 'Nome do usuario.'
        optional :email, desc: 'E-mail do usuario.'
        optional :url_photo, desc: 'E-mail do usuario.'
        optional :url_face, desc: 'Nome do usuario.'
      end
      post :login_face do
        hash = FaceControl.instance.auth(params)
        { "hash" => hash}
      end
      
      params do
        requires :username, desc: 'username/email para login.'
        requires :password, desc: 'password para login.'
      end
      post :login do
        
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

    resource :lines do
      params do
        requires :codes, type: Array, desc: 'códigos da lines que deseja'
      end
      get '/get', :rabl => "lines.rabl" do
        @lines = Line.where(code: params[:codes]).order('code ASC')
        if !@lines
          error!({ erro: 'Line não encontrada.', detalhe: 'Verifique o code passado por parametro.' }, 404)
        end
        @lines
      end

      params do
        optional :search, desc: 'termo para search da line.'
      end
      desc 'Retornas as lines registradas, filtradas ou não pelo parâmetro search.'
      get '/', :rabl => "lines.rabl" do
        search = params[:search]
        if(search)
          puts search
          sql = "code like ? OR denominacao like ? OR retorno like ?"
          search = ActiveSupport::Inflector.transliterate(search)
          search = search.upcase
          split = search.split
          @lines = Set.new
          split.each do |termo|
              puts "> #{ termo }"
              @lines = @lines + Line
                          .where(sql, "%#{termo}%", "%#{termo}%","%#{termo}%")
                          .order("code asc")
          end
        else
          @lines = Line.order(:code)
        end
      end

      desc 'Recarrega todas as Lines e salva com base na API Integrah.'
      get :load do
        LoadLinesStops.new.init
      end

      desc 'Pega as lines da para com o código passado.'
      params do
        requires :code, desc: 'código da stop que deseja as lines.'
      end
      get 'stop/:code', :rabl => "lines.rabl" do
        stop = Stop.find_by_code(params[:code])
        if stop
          @lines = stop.lines.order('code ASC')
        else
          error!({ erro: 'Stop nao registrada', detalhe: 'Verifique o code passado por parametro.' }, 404)
        end
      end

    end #resource :line

    resource :stops do
      
      desc 'Retornas as stops registradas, filtradas ou não pelo parâmetro código.'
      params do
	      requires :code, desc: 'código da stop.'
      end
      get '/', :rabl => "stops.rabl"  do
          @stops = Stop.find_by_code(params[:code]) ||
          error!({ erro: 'Stop nao registrada', detalhe: 'Verifique o code passado por parametro.' }, 404)
      end

      get :all, :rabl => "stops_basic.rabl" do
        @stops = Stop.includes(:lines)
      end

      params do
        requires :code, desc: 'código da stop que será feito o checkin.'
      end
      post :checkin do
        check_in = Checkin.new
        check_in.user = current_user
        check_in.stop = Stop.find_by_code(params[:code])
        check_in.save!
      end

      params do
        requires :lat, type:  Float
        requires :long, type: Float
        requires :dist, type: Float
      end
      get :proximas, :rabl => "stops.rabl" do
        @stops = StransAPi.instance.stops_proximas(params[:long], params[:lat], params[:dist])
        if(!@stops || @stops.empty?)
          @stops = StransAPi.instance.stops_proximas(params[:long], params[:lat], (params[:dist] * 2))
        end
      end

    end

    resource :vehicles do

      get :agora, :rabl => "vehicles.rabl" do
        @vehicles = BusCache.instance.all
      end

      get "agora/count" do
        { count: BusCache.instance.all.size }
      end

      get :load do
        LoadVehicles.new.init
      end

      params do
        requires :code, desc: 'código do veciculo.'
      end
      get "/:code", :rabl => "vehicle.rabl" do
        @vehicle = BusCache.instance.get(params[:code])
        if(!@vehicle)
          error!({ erro: 'Vehicle não encontrado', detalhe: 'Apenas vehicles rodando encontram-se disponiveis aqui.' }, 404)
        end
      end

      params do
        requires :code, desc: 'código da line que deseja os veículos.'
      end
      get "line/:code", :rabl => "vehicles.rabl" do
        @vehicles = BusCache.instance.get_by_line(params[:code])
      end

      params do
        requires :code, desc: 'código do veículo que será feito o checkin.'
      end
      post :checkin do
        vehicle = BusCache.instance.get(params[:code])
        if(vehicle)
          check_in = Checkin.new
          check_in.user = current_user
          check_in.vehicle = vehicle
          return check_in.save!
        end
        error!({ erro: 'Vehicle não encontrado', detalhe: 'Não podemos fazer login em um vehicle que não se encontra rodando.' }, 404)
      end

    end

    params do
      requires :type, values: ['con','seg','mov','pon','ace','est']
      requires :code
    end
    resource :interaction do
      get ':type/stop/:code', :rabl => "interactions.rabl" do
        @type = Interaction.type_s[params[:type]]
        stop = Stop.find_by_code(params[:code])
        error!({ erro: 'Stop não encontrada', detalhe: 'Verifique o code passado por parametro.' }, 404) if !stop
        @reputation = stop.reputation
        @interactions = @reputation.interactions_type(@type)
      end
      get ':type/vehicle/:code', :rabl => "interactions.rabl" do
        code = params[:code]
        @type = Interaction.type_s[params[:type]]
        vehicle = Vehicle.find_by_code(code)
        error!({ erro: 'Vehicle não encontrado', detalhe: 'Verifique o code passado por parametro.' }, 404) if !vehicle
        @reputation = vehicle.reputation
        @interactions = @reputation.interactions_type(@type)
      end

      params do
        requires :evaluation, values: Interaction.evaluations.values
        requires :comment
        requires :id_facebook
      end
      post ':type/stop/:code',:rabl => "result.rabl" do
        i = Interaction.new
        i.user = User.find_by_id_facebook(params[:id_facebook])
        i.type_ = params[:type]
        i.comment = params[:comment]
        i.evaluation = params[:evaluation]
        @result = Result.new
        stop = Stop.find_by_code(params[:code])
        if(stop)
          stop.reputation ||= Reputation.new
          stop.reputation.interactions << i
          @result.status = stop.save! ? "sucess" : "error"
        else
          @result.status = "error"
          @result.mensage = "Stop não encontrada."
        end
      end

      params do
        requires :evaluation, values: Interaction.evaluations.values
        requires :comment
        requires :id_facebook
      end
      post ':type/vehicle/:code', :rabl => "result.rabl" do
        i = Interaction.new
        i.user = User.find_by_id_facebook(params[:id_facebook])
        i.type_ = params[:type]
        i.comment = params[:comment]
        i.evaluation = params[:evaluation]
        @result = Result.new
        vehicle = Vehicle.find_by_code(params[:code])
        if(vehicle)
          vehicle.reputation ||= Reputation.new
          vehicle.reputation.interactions << i
          @result.status = vehicle.save! ? "sucess" : "error"
        else
          @result.mensage = "Vehicle não encontrado."
        end
       end
    end

    # limite de interacitions por tela.
    #LIMIT = 10
    params do
      requires :type, values: ['con','seg','mov','pon','ace','est']
      requires :code
    end
    resource :interactions do

      get ':type/stop/:code', :rabl => "interactions.rabl" do
        @type = Interaction.type_s[params[:type]]
        stop = Stop.find_by_code(params[:code])
        error!({ erro: 'Stop não encontrada', detalhe: 'Verifique o code passado por parametro.' }, 404) if !stop
        @reputation = stop.reputation
        @interactions = @reputation.interactions_type(@type)
      end

      get ':type/vehicle/:code', :rabl => "interactions.rabl" do
        code = params[:code]
        @type = Interaction.type_s[params[:type]]
        vehicle = Vehicle.find_by_code(code)
        error!({ erro: 'Vehicle não encontrado', detalhe: 'Verifique o code passado por parametro.' }, 404) if !vehicle
        @reputation = vehicle.reputation
        @interactions = @reputation.interactions_type(@type)
      end

      params do
        requires :evaluation, values: Interaction.evaluations.values
        requires :comment
        requires :id_facebook
      end
      post ':type/stop/:code' do
        i = Interaction.new
        i.user = User.find_by_id_facebook(params[:id_facebook])
        i.type_ = params[:type]
        i.comment = params[:comment]
        i.evaluation = params[:evaluation]
        stop = Stop.find_by_code(params[:code])
        stop.reputation ||= Reputation.new
        stop.reputation.interactions << i
        stop.save!
      end

      params do
        requires :evaluation, values: Interaction.evaluations.values
        requires :comment
      end
      post ':type/vehicle/:code' do
        i = Interaction.new
        i.user = User.find_by_id_facebook(params[:id_facebook])
        i.type_ = params[:type]
        i.comment = params[:comment]
        i.evaluation = params[:evaluation]
        vehicle = Vehicle.find_by_code(params[:code])
        error!({ erro: 'Vehicle não encontrado', detalhe: 'Verifique o code passado por parametro.' }, 404) if !vehicle
        vehicle.reputation ||= Reputation.new
        vehicle.reputation.interactions << i
        vehicle.save!
      end
   end

    RAIO_BUSCA_APP = 500
    
    resource :stopsvehicles do
      params do
        requires :lat, type:  Float
        requires :long, type: Float
        requires :code
      end
      get "line/:code", :rabl => "stops_vehicles.rabl" do
        @line = Line.find_by_code(params[:code])
        if(@line)
          lon = params[:long]
          lat = params[:lat]
          @stops = StransAPi.instance.stops_proximas(lon, lat, RAIO_BUSCA_APP, @line.stops)
          if(!@stops || @stops.empty?)
            @stops = StransAPi.instance.stops_proximas(lon, lat, (RAIO_BUSCA_APP * 2), @line.stops)
          end
          @vehicles = BusCache.instance.get_by_line(params[:code])
          @vehicles.each{|v| v.line = @line.code } if @vehicles
          return
        end
        error!({ erro: 'Line nao encontrada', detalhe: 'Verifique o code da line passado por parametro.' }, 404)
      end

      params do
        requires :lat, type:  Float
        requires :long, type: Float
        requires :codes, type: Array
      end
      get 'line', rabl: 'stops_vehicles0.rabl' do
        lines = Line.where(code: params[:codes]).order('code ASC')
        @vehicles = []
        @stops = []
        if lines && !lines.empty?
          lines.each do |line|
            lon = params[:long]
            lat = params[:lat]
            stops = StransAPi.instance.stops_proximas(lon, lat, RAIO_BUSCA_APP, line.stops)
            if stops.empty?
              stops = StransAPi.instance.stops_proximas(lon, lat, (RAIO_BUSCA_APP * 2), line.stops)
            end
            @stops.concat(stops)
            vehicles = BusCache.instance.get_by_line(line.code)
            if vehicles && !vehicles.empty?
              vehicles.each { |v| v.line.code = line.code }
              @vehicles.concat(vehicles)
            end
          end
          @stops = Set.new(@stops)
          @vehicles = Set.new(@vehicles)
          return
        end
        error!({ erro: 'Line nao encontrada', detalhe: 'Verifique o(s) code(s) da(s) line(s) passado por parametro.' }, 404)
      end
    end
  end #class
end #module
