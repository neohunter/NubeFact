module NubeFact::Validator
  def validate!
    #ToDO change for a real validator like ActiveModel::Validations or Hanami::Validations
    self.class::REQUIRED_FIELDS.each do |field|
      if send(field).nil?
        raise NubeFact::ValidationError.new "#{field} it's a required field."
      end
    end
    true
  end
end