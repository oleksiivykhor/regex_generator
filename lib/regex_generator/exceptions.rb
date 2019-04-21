module RegexGenerator
  class TargetNotFoundError < StandardError
    def message
      'The target was not found in the provided text'
    end
  end

  class TitleNotFoundError < StandardError
    def message
      'The title was not found in the provided text'
    end
  end

  class InvalidOption < StandardError
    def initialize(*options)
      @options = options
    end

    def message
      "Invalid option(s): #{@options}"
    end
  end
end
