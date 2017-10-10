require 'spec_helper'

# ==== WARNING WIP
# This test are just a basic draft, currenlty it does real net connections 
# to the providers, which is not good idea.
# ==== WARNING WIP
describe NubeFact::Sunat do
  def stub_requets!
    # move this to text file
    stub_request(:get, "https://api.preciodolar.com/api/history/?bank_id=13&country=pe&source=bank&time_interval=day")
             .to_return(status: 200, body: %q([{"buy":3.269,"sell":3.265,"date":"2017-05-06 00:04:14"},{"buy":3.269,"sell":3.265,"date":"2017-10-10 10:14:56"}]), headers: {})
  end

  before do
    # stub_requets!
    WebMock.allow_net_connect!
  end

  describe '#dollar_rate' do
    it 'should call dollar_from_sunat if dolar_price return error' do
      allow(subject).to receive(:dollar_from_preciodolar).and_raise(StandardError)
      expect(subject).to receive(:dollar_from_sunat)
      subject.dollar_rate
    end
  end

  describe '#dollar_from_preciodolar' do
    it 'should retrieve dolar price' do
      expect(subject.dollar_from_preciodolar).to eq(3.265)
    end
  end

  describe '#dollar_from_sunat' do
    # This tests are not good idea.
    it 'should return a valid dollar amount' do
      expect(subject.dollar_from_sunat).to be > 2.5
      expect(subject.dollar_from_sunat).to be < 3.5
    end
  end
end 