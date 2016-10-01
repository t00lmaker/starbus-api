require 'require_models'

def app
  StarBus::API.new
end

describe 'Starbus API v1' do
  before { StarBus::API.before { env["api.tilt.root"] = "rabl" } }

  describe :linhas do
    before do
      allow(Linha).to receive(:where) { Linha }
      allow(Linha).to receive(:order) { [] }
    end

    it "GET / no params" do
      get 'v1/linhas'
      puts ">>>>>> #{last_response.body} <<<<<"
    end
    it "GET / no params" do
      get 'v1/linhas?busca=505'
      puts ">>>>>> #{last_response.body} <<<<<"
    end
  end
end
