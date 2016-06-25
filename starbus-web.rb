require 'sinatra/base'
module StarBus

  class Web < Sinatra::Base

    get "/" do
     erb :landingpage
    end

  end
end
