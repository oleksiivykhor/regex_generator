module RegexGenerator
  class Target
    # @param target [String, Integer, Float, Hash] target string or hash with
    #   named targets
    def initialize(target)
      @target = target
    end

    # @param text [String] which should contains the target
    # @return [true, false]
    def present?(text)
      return to_s.values.all? { |t| text[t] } if kind_of? Hash

      !text[to_s].nil?
    end

    # Converts target to string (or values to strings if target is a Hash)
    #
    # @return [String, Hash]
    def to_s
      return @target.to_s unless @target.kind_of? Hash

      @target.each_with_object({}) do |(key, value), result|
        result[key] = value.to_s
      end
    end

    # Checks type of the target's string representation
    #
    # @param type [Class]
    # @return [true, false]
    def kind_of?(type)
      to_s.kind_of? type
    end

    # Escapes values
    #
    # @option keys [true, false] returns Hash with escaped values when true
    # @return [String, Array, Hash]
    def escape(keys: false)
      return Regexp.escape to_s if kind_of? String
      return to_s.values.map { |v| Regexp.escape v } unless keys

      to_s.each_with_object({}) do |(key, value), result|
        result[key] = Regexp.escape value
      end
    end
  end
end
