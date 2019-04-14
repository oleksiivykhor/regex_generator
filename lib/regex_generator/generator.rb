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
      @target = RegexGenerator::Target.new(target)
      @target_str = @target.to_s
      @options = options
    end

    # @return [Regexp]
    # @raise [TargetNotFoundError] if target text was not found in the text
    def generate
      raise RegexGenerator::TargetNotFoundError unless @target.present?(@text)

      string_regex_chars = recognize_text(cut_nearest_text, options)
      string_patterns_array = slice_to_identicals(string_regex_chars)
      string_regex_str = join_patterns(string_patterns_array)

      Regexp.new string_regex_str
    end

    private

    # Cuts nearest to target, text from the start of the string
    def cut_nearest_text
      start_pattern = @text[/\n/] ? /\n/ : /^/

      if @target.kind_of? Hash
        target_regex = /(?:#{@target.escape.join('|')})/
        text_regex_str = (1..@target_str.count).map do |step|
          all = step.eql?(1) ? '.' : '[\w\W]'
          "#{all}+?#{target_regex}"
        end.join
        text_regex = Regexp.new "#{start_pattern}#{text_regex_str}"

        return @text[text_regex]
      end

      regex = /[\w\W]*(#{start_pattern}[\w\W]+?)#{Regexp.escape(@target_str)}/
      @text[regex, 1]
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

      if @options[:self_recognition].kind_of? String
        @options[:self_recognition] = @options[:self_recognition].chars
      end

      @options
    end

    # Recognizes target depending on type (String or Hash)
    def target_patterns
      return @target.escape(keys: true) if @options[:exact_target]

      if @target.kind_of? Hash
        @target_str.each_with_object({}) do |(key, value), patterns|
          slices_patterns = slice_to_identicals(recognize(value, options))
          patterns[key] = join_patterns(slices_patterns)
        end
      else
        target_patterns_array = slice_to_identicals(recognize(@target, options))
        join_patterns(target_patterns_array)
      end
    end

    # Recognizes text depending on target type
    def recognize_text(text, options = {})
      unless @target.kind_of? Hash
        return recognize(text, options) << "(#{target_patterns})"
      end

      target_regex = /#{@target.escape.join('|')}/
      text.split(/(#{target_regex})/).map do |str|
        next recognize(str, options) unless str[target_regex]

        key = @target_str.key(str)
        "(?<#{key}>#{target_patterns[key]})"
      end.flatten
    end

    def recognize(text, options = {})
      RegexGenerator::CharactersRecognizer.recognize(text.to_s, options)
    end
  end
end
