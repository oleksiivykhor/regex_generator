module RegexGenerator
  class Generator
    # rubocop:disable Metrics/LineLength
    #
    # @param target [String] what you want to find
    # @param text [String] source text
    # @param options [Hash] options to generate regex with
    # @option options [true, false] :exact_target to generate regex with exact target value
    #
    # rubocop:enable Metrics/LineLength
    def initialize(target, text, options = {})
      @text = text
      @target = target
      @options = options
    end

    # @return [Regexp]
    def generate
      raise RegexGenerator::TargetNotFoundError unless @text[@target]

      string_patterns_array = slice_to_identicals(recognize(cut_nearest_text))
      string_regex_str = join_patterns(string_patterns_array)
      target_regex_str = if @options[:exact_target]
        Regexp.escape @target
      else
        target_patterns_array = slice_to_identicals(recognize(@target))
        join_patterns(target_patterns_array)
      end

      Regexp.new("#{string_regex_str}(#{target_regex_str})")
    end

    private

    # Cuts nearest to target, text from the start of the string
    def cut_nearest_text
      start_pattern = @text[/\n/] ? /\n/ : /^/
      @text[/[\w\W]*(#{start_pattern}[\w\W]+?)#{Regexp.escape(@target)}/, 1]
    end

    # Slices array to subarrays with identical neighbor elements
    def slice_to_identicals(array)
      result = []
      intermediate_array = []
      array.each_with_index do |item, index|
        intermediate_array << item
        next if item.eql? array[index + 1]

        result << intermediate_array.dup
        intermediate_array.clear
      end

      result
    end

    # Joins patterns by count, i.e. returns pattern with '+' instead array
    # with a multiple identical patterns
    def join_patterns(array)
      array.map do |patterns|
        patterns.one? ? patterns.first : "#{patterns.first}+"
      end.join
    end

    def recognize(text)
      RegexGenerator::CharactersRecognizer.recognize(text)
    end
  end
end
