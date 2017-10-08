require 'spec_helper'

describe NubeFact do
  it "should have a VERSION" do
    expect(NubeFact::VERSION).to match(/^\d+\.\d+\.\d+$/)
  end

  describe '#url' do
    it 'should return a url with url_token' do
      NubeFact.url_token = 'abc'
      url = NubeFact.url
      
      expect(url).to be_a(URI)
      expect(url.to_s).to eq("https://www.nubefact.com/api/v1/abc")
    end

  end

  describe '#request' do
    it 'should respond to request' do
      expect(NubeFact).to respond_to(:request)
    end

    context 'when api keys are not set' do
      it 'should raise NubeFact::NotConfigured' do
        expect{ NubeFact.request(nil) }.to raise_error(NubeFact::NotConfigured)
      end

      it 'should raise NubeFact::NotConfigured if only url_token is set' do
        NubeFact.api_token = nil
        NubeFact.url_token = 'abc'
        expect{ NubeFact.request(nil) }.to raise_error(NubeFact::NotConfigured)
      end

      it 'should raise NubeFact::NotConfigured if only api_token is set' do
        NubeFact.api_token = '123'
        NubeFact.url_token = nil
        expect{ NubeFact.request(nil) }.to raise_error(NubeFact::NotConfigured)
      end
    end

    context 'when response is an error' do
      it 'should raise ErrorResponse' do
      # {
      #   "errors": "El archivo enviado no cumple con el formato establecido",
      #   "codigo": 20
      # }

      end
    end
  end
end 