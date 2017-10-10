module NubeFact::Utils
  # This iterates over all fields and if is an array (items and guias) converts
  # it to hash using to_h
  def to_h
    Hash[self.class::FIELDS.map do |field| 
      value = send(field)
      value = value.map &:to_h if value.is_a? Array
      [field, value]
    end]
  end

  def to_json(options = {})
    self.to_h.to_json options
  end

  # Fix to bug due to ActiveSupport::Serialization JSON.
  #  it calls as_json in order to get the hash representation of the object
  #  ActiveSupport uses all object attributes, including item.invoice who force
  #  the json convertion into an infinite loop:
  #.  (invoice -> items -> item ->  invoice -> items -> item ...)
  def as_json(options={})
    Hash[to_h.map { |k, v| [k.to_s, options ? v.as_json(options.dup) : v.as_json] }]
  end

  private
    def set_default_data
      self.class::DEFAULT_DATA.each do |field, value|
        next if send(field)

        value = value.call(self) if value.kind_of? Proc
        send "#{field}=", value
      end
    end

    def load_data_from_param(data_hash)
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

      set_default_data
    end
end