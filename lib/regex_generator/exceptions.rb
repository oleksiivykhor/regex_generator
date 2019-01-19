module RegexGenerator
  class TargetNotFoundError < StandardError
    def message
      'The target was not found in the provided text'
    end
  end
end
