require 'sinatra/base'
require 'timerizer'

module StarBus
  class Web < Sinatra::Base
    get "/" do
     puts " < landingpage >"
     erb :landingpage
    end
    get "/dashboard" do
      erb :dashboard
    end
    get "/snapshots" do
      content_type :json
      _snaps = Snapshot.where(data: 6.hour.ago..Time.now).order(:data)
      @snaps = {}
      _snaps.each do |s|
        @snaps[s.data.strftime('%H:%M')] = JSON.parse(s.value)
      end
      @snaps.to_json
    end
  end
end
