require 'grape'

module StarBus
  class API < Grape::API
    version 'v1'
    format  :json
    prefix  :api

    helpers do
     def current_user
       @current_user ||= User.authorize!(env)
     end

     def authenticate!
       error!('401 Não Autenticado!', 401) unless current_user
     end
    end

    resource :linhas do
      desc 'Retorna todas as linha da cidade de Teresina.'
      get '/' do
        authenticate!
         {:hello => 'world'}.to_json
      end
    end


  end
end
