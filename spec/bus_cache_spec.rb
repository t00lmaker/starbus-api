require 'require_models'
require './lib/buscache.rb'


describe BusCache do

    before(:example) do
      @cache = BusCache.instance
    end

    context 'valid?' do
      it 'deve retornar instancias de Linha' do
        linhas = @client.get(:linhas)
        expect(linhas).to be_an_instance_of(Array)
        expect(linhas.size).to be > 0
        expect(linhas[0]).to be_an_instance_of(LinhaStrans)
        expect(linhas[0]).to_not be_nil
        expect(linhas[0].codigo).to_not be_nil
      end
    end
end
