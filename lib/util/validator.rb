module NubeFact::Validator
  # Following methods solve the issue of having required fields inherits from a base class

  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    # When a class is inherited eg. Invoice, it sets the required fields from 
    # the base class eg. Document to use it as a base
    def inherited(child_class)
      child_class.instance_variable_set :@required_fields, self.required_fields
    end

    def add_required_fields(*fields)
      @required_fields = required_fields + fields
    end

    def required_fields
      @required_fields || []
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