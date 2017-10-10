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
    stub_requets!
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
    before do
      WebMock.allow_net_connect!
    end

    # This tests are not good idea.
    it 'should return a valid dollar amount' do
      expect(subject.dollar_from_sunat).to be > 2.5
      expect(subject.dollar_from_sunat).to be < 3.5
    end

    it 'should grab a valid matrix of historical rates' do
      october_2016 = {
         1 => 3.403,
        18 => 3.400,
        27 => 3.367,
        31 => 3.363,
      }

      october_2016.each do |day, expected_rate|
        date = Date.new(2016, 10, day)
        expect(subject.dollar_from_sunat(date)).to eq(expected_rate)
      end
    end

    it 'should grab the rate of the previous month if is not available' do
      date = Date.new(2017, 07, 1)
      expect(subject.dollar_from_sunat(date)).to eq(3.255)
    end


    context 'when invalid date' do
      it 'should raise InvalidDate error' do
        date = Date.new(1994, 07, 1)
        expect{ subject.dollar_from_sunat(date) }.to raise_error(NubeFact::Sunat::InvalidDate)

        date = Date.new(3000, 07, 1)
        expect{ subject.dollar_from_sunat(date) }.to raise_error(NubeFact::Sunat::InvalidDate)
      end
    end
  end
end 