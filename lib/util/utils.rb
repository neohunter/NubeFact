module NubeFact::Utils
  def to_h
    Hash[self.class::FIELDS.map{|field| [field, send(field)]}]
  end

  def to_json(options = {})
    JSON.generate self.to_h, options
  end

  private
    def set_default_data
      self.class::DEFAULT_DATA.each do |field, value|
        value = value.call if value.kind_of? Proc
        instance_variable_set("@#{field}", value)
      end
    end

    def load_data_from_param(data_hash)
      set_default_data

      data_hash.each do|key, value|
        if self.class.const_defined?('AUTO_CALCULATED_FIELDS') \
          && self.class::AUTO_CALCULATED_FIELDS.include?(key)
          warn("field #{key} will be calculated automatically, you don't need to pass it.")
        end
        
        begin
          send "#{key}=", value
        rescue NoMethodError => e
          raise NubeFact::InvalidField.new "Invalid Field: #{key}"
        end
      end
    end
end