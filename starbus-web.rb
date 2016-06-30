require 'sinatra/base'
module StarBus

  class Web < Sinatra::Base

    get "/" do
     puts " < landingpage >"
     erb :landingpage
    end

  end
end
