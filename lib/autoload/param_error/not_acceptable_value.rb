module ParamError
  class NotAcceptableValue < StandardError
    def initialize(param, value, acceptable_values)
      super("'#{param}' has not acceptable value '#{value.nil? ? 'nil' : value}'.
            Acceptable values are '#{acceptable_values.join(', ')}'")
    end
  end
end
