require 'spec_helper'

describe NubeFact::Invoice do
  subject {
    NubeFact::Invoice.new params
  }
  let(:params) { Hash.new }
  let!(:valid_params) do
    Hash[NubeFact::Invoice::REQUIRED_FIELDS.map{|k| [k, 'abc']}]
  end

  describe '#initialize' do
    it 'should not allow incorrect fields' do
      params = {a: 1}
      expect{ NubeFact::Invoice.new params }.to raise_error NubeFact::InvalidField
    end

    it 'should set provided values' do
      invoice = NubeFact::Invoice.new({serie: 'abc'})
      expect(invoice.serie).to eq 'abc'

      field = NubeFact::Invoice::FIELDS.sample
      invoice = NubeFact::Invoice.new({field => 'def'})
      expect(invoice.send(field)).to eq 'def'
    end

    it 'should set items and guias as empty arrays' do
      expect(subject.items).to eq([])
      expect(subject.guias).to eq([])
    end

    it 'should set default data' do
      expect(subject.operacion).to eq('generar_comprobante')
      expect(subject.sunat_transaction).to eq(1)
      expect(subject.fecha_de_emision).to eq(Time.now.strftime(NubeFact::DATE_FORMAT))
    end

    it 'should overwrite default data with params' do
      invoice = NubeFact::Invoice.new({serie: 'abc'})
      expect(invoice.serie).to eq 'abc'
    end

  end

  # ToDO move this to shared_examples, is duplicated on invoice and item
  describe '#validate!' do
    context 'when a required field is missing' do
      it 'should raise ValidationError error ' do
        expect{ subject.validate! }.to raise_error NubeFact::ValidationError
      end
    end

    context 'when all required fields are set' do
      let(:params){ valid_params }
      it 'should not raise error ' do
        expect{ subject.validate! }.to_not raise_error
      end
      it 'should be truty' do
        expect(subject.validate!).to be_truthy
      end
    end
  end

  describe '#deliver' do
    let(:params){ valid_params }
    let(:item) do
      instance_double('Item', to_h: {})
    end

    before do
      subject.add_item( item )
      allow(NubeFact).to receive(:request)
    end

    context 'when no items are added' do
      before{ subject.items = [] }
      it 'should raise ValidationError' do
        expect { subject.deliver }.to raise_error NubeFact::ValidationError
      end
    end
    
    it 'should call validate!' do
      expect(subject).to receive(:validate!)
      subject.deliver
    end

    it 'should call NubeFact.request' do
      expect(NubeFact).to receive(:request).with(subject.to_h)
      subject.deliver
    end

  end

  describe '#add_item' do
    context 'when given a hash' do
      let(:param){ Hash.new }
      it 'should create an Item from hash' do
        expect(NubeFact::Invoice::Item).to receive(:new).with(subject, param)
        subject.add_item param
      end
    end

    context 'when given a Item' do
      let(:param){ instance_double('Item') }
      it 'should add param to @items array' do
        subject.add_item param
        expect(subject.items.first).to eq(param)
      end
    end
  end

  describe '#to_json' do
    let(:params){ valid_params }
    it 'should return json representation' do
      expect(subject.to_json).to eq(subject.to_h.to_json)
    end
  end
end 