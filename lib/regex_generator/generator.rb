module RegexGenerator
  class Generator
    # @param target [String, Integer, Float, Hash] target string or hash with
    #   named targets
    # @param text [String] source text
    # @param options [Hash] options to generate regex with
    # @option options [true, false] :exact_target to generate regex
    #   with exact target value
    # @option options [String, Array] :self_recognition to recognize chars as
    #   itself
    def initialize(target, text, options = {})
      @text = text
      @target = target_to_s(target)
      @options = options
    end

    # @return [Regexp]
    # @raise [TargetNotFoundError] if target text was not found in the text
    def generate
      raise RegexGenerator::TargetNotFoundError unless target_present?

      string_regex_chars = recognize_text(cut_nearest_text, options)
      string_patterns_array = slice_to_identicals(string_regex_chars)
      string_regex_str = join_patterns(string_patterns_array)

      Regexp.new string_regex_str
    end

    private

    # Cuts nearest to target, text from the start of the string
    def cut_nearest_text
      start_pattern = @text[/\n/] ? /\n/ : /^/
      if @target.is_a? Hash
        target_regex = /(?:#{escaped_target.join('|')})/
        text_regex_str = (1..@target.count).map do |step|
          all = step.eql?(1) ? '.' : '[\w\W]'
          "#{all}+?#{target_regex}"
        end.join
        text_regex = Regexp.new "#{start_pattern}#{text_regex_str}"
        @text[text_regex]
      else
        @text[/[\w\W]*(#{start_pattern}[\w\W]+?)#{Regexp.escape(@target)}/, 1]
      end
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

    # Prepares options
    def options
      return @options unless @options.any?

      if @options[:self_recognition].is_a? String
        @options[:self_recognition] = @options[:self_recognition].chars
      end

      @options
    end

    def target_to_s(target)
      return target.to_s unless target.is_a? Hash

      target.each_with_object({}) do |(key, value), result|
        result[key] = value.to_s
      end
    end

    # Checks if target is present in the text
    def target_present?
      return @target.values.all? { |t| @text[t] } if @target.is_a? Hash

      !@text[@target].nil?
    end

    # If keys false, method returns array with escaped values, otherwise hash
    # with escaped values (only if target is a hash)
    def escaped_target(keys: false)
      return Regexp.escape @target if @target.is_a? String
      return @target.values.map { |v| Regexp.escape v } unless keys

      @target.each_with_object({}) do |(key, value), result|
        result[key] = Regexp.escape value
      end
    end

    # Recognizes target depending on type (String or Hash)
    def target_patterns
      return escaped_target(keys: true) if @options[:exact_target]

      if @target.is_a? Hash
        @target.each_with_object({}) do |(key, value), patterns|
          slices_patterns = slice_to_identicals(recognize(value))
          patterns[key] = join_patterns(slices_patterns)
        end
      else
        target_patterns_array = slice_to_identicals(recognize(@target))
        join_patterns(target_patterns_array)
      end
    end

    # Recognizes text depending on target type
    def recognize_text(text, options = {})
      unless @target.is_a? Hash
        return recognize(text, options) << "(#{target_patterns})"
      end

      target_regex = /#{escaped_target.join('|')}/
      text.split(/(#{target_regex})/).map do |str|
        next recognize(str, options) unless str[target_regex]

        key = @target.key(str)
        "(?<#{key}>#{target_patterns[key]})"
      end.flatten
    end

    def recognize(text, options = {})
      RegexGenerator::CharactersRecognizer.recognize(text, options)
    end
  end
end
