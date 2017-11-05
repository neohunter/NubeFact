require 'spec_helper'

describe NubeFact::Document::Item do
  let!(:invoice) do
    instance_double('Invoice', porcentaje_de_igv: 20)
  end
  subject {
    described_class.new invoice, params
  }
  let(:params) { Hash.new }
  let!(:valid_params) do
    {
         descripcion: 'Prueba',
            cantidad: 2,
      valor_unitario: 100,
         tipo_de_igv: 1
    }
  end

  context 'required fields' do
    let(:params){ valid_params }

    it 'should have valid required fields' do
      required_fields = %i(
        unidad_de_medida
        descripcion
        cantidad
        valor_unitario
        tipo_de_igv
      )
      expect(subject.class.required_fields).to eq(required_fields)
    end
  end

  describe '#initialize' do
    before do
      allow_any_instance_of(NubeFact::Document::Item).to receive(:validate!)
      allow_any_instance_of(NubeFact::Document::Item).to receive(:calculate_amounts)
    end
    it 'should not allow incorrect fields' do
      params = {a: 1}
      expect{ NubeFact::Document::Item.new nil, params }.to raise_error NubeFact::InvalidField
    end

    it 'should set provided values' do
      item =  NubeFact::Document::Item.new(nil, {unidad_de_medida: 'abc'})
      expect(item.unidad_de_medida).to eq 'abc'

      field = NubeFact::Document::Item::FIELDS.sample
      item =  NubeFact::Document::Item.new(nil, {field => 'def'})
      expect(item.send(field)).to eq 'def'
    end

    it 'should set default data' do
      expect(subject.unidad_de_medida).to eq('ZZ')
      expect(subject.anticipo_regularizacion).to be_falsy
    end

    it 'should overwrite default data with params' do
      item =  NubeFact::Document::Item.new(nil, {unidad_de_medida: 'NIU'})
      expect(item.unidad_de_medida).to eq 'NIU'
    end

    it 'should call validate!' do
      expect_any_instance_of(NubeFact::Document::Item).to receive(:validate!)
      subject
    end

    it 'should add a warn if passed a field that will be auto calculated' do
      expect_any_instance_of(NubeFact::Document::Item).to receive("warn")
      NubeFact::Document::Item.new(nil, {total: 100})
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

  describe '#calculate_amounts' do
    subject{ NubeFact::Document::Item.new invoice, valid_params }

    it 'should calculate values' do
      subject.calculate_amounts

      expect(subject.igv).to eq(40)
      expect(subject.precio_unitario).to eq(120)
      expect(subject.subtotal).to eq(200)
      expect(subject.total).to eq(240)
    end

    it 'should apply discount' do
      subject.descuento = 50
      subject.calculate_amounts

      expect(subject.subtotal).to eq(150)
      expect(subject.total).to eq(190)
    end


  end

  describe '#should_add_igv?' do

    subject{ NubeFact::Document::Item.new invoice, valid_params }

    it 'should be truthy if tipo_de_igv must add igv' do
      NubeFact::Document::Item::TYPES_SUBJECT_TO_IGV.each do |v|
        subject.tipo_de_igv = v
        expect(subject.should_add_igv?).to be_truthy
      end
    end

    it 'should be false if tipo_de_igv is not present on TYPES_SUBJECT_TO_IGV' do
      subject.tipo_de_igv = 99
      expect(subject.should_add_igv?).to be_falsy
    end
  end

end 