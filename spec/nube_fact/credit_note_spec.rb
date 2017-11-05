require 'spec_helper'

describe NubeFact::CreditNote do
  subject {
    NubeFact::CreditNote.new params
  }
  let(:params) { Hash.new }
  let!(:valid_params) do
    Hash[described_class.required_fields.map{|k| [k, 'abc']}]
  end

  before do
    allow(NubeFact::Sunat).to receive(:dollar_rate)
  end

  it 'should have valid required fields' do
    expect(subject.class.required_fields).to include(:documento_que_se_modifica_tipo, 
                                                     :documento_que_se_modifica_serie,
                                                     :documento_que_se_modifica_numero,
                                                     :tipo_de_nota_de_credito)
    expect(subject.class.required_fields).to include(*NubeFact::Document.required_fields)
  end
end 