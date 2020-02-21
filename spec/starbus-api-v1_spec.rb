require 'require_models'

def app
  StarBus::API.new
end

describe 'Starbus API v1' do
  before { StarBus::API.before { env["api.tilt.root"] = "rabl" } }

  describe :lines do
    before do
      allow(Line).to receive(:where) { Line }
      allow(Line).to receive(:order) { [] }
    end

    it "GET / no params" do
      get 'v1/lines'
      puts ">>>>>> #{last_response.body} <<<<<"
    end
    it "GET / no params" do
      get 'v1/lines?search=505'
      puts ">>>>>> #{last_response.body} <<<<<"
    end
  end
end
