module NubeFact::Validator
  def self.included(klass)
    klass.extend ClassMethods
    klass.class_variable_set :@@required_fields, []
  end

  module ClassMethods
    def add_required_fields(*fields)
      base = required_fields 
      
      self.class_variable_set :@@required_fields, \
        required_fields + fields
    end

    def required_fields
      required_fields = self.class_variable_get :@@required_fields
      return self::REQUIRED_FIELDS if required_fields.empty?
      required_fields
    end
  end

  def validate!
    #ToDO change for a real validator like ActiveModel::Validations or Hanami::Validations
    self.class::required_fields.each do |field|
      if send(field).nil?
        raise NubeFact::ValidationError.new "#{field} it's a required field."
      end
    end
    true
  end
end