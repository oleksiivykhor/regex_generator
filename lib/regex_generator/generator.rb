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
    # @option options [:ahead, :behind] :look to generate regex with text before
    #   or after the target
    # @option options [true, false] :strict_count to generate regex with a
    #   strict chars count
    # @option options [String, Hash] :title to generate regex for provided title
    def initialize(target, text, options = {})
      @text = text
      @target = RegexGenerator::Target.new(target)
      @title = RegexGenerator::Target.new(options[:title])
      if options[:title] && !@title.keys_equal?(@target)
        raise RegexGenerator::InvalidOption, :title
      end

      @title_str = @title.to_s
      @target_str = @target.to_s
      @options = options
    end

    # @return [Regexp]
    # @raise [TargetNotFoundError] if target text was not found in the text
    # @raise [InvalidOption] if :look option is not :ahead or :behind or :title
    #   has different keys than target keys
    # @raise [TitleNotFoundError] if :title was not found in the text
    def generate
      raise RegexGenerator::TargetNotFoundError unless @target.present?(@text)
      raise RegexGenerator::TitleNotFoundError unless @title.present?(@text)

      string_regex_chars = recognize_text(cut_nearest_text, options)
      string_patterns_array = slice_to_identicals(string_regex_chars)
      string_regex_str = join_patterns(string_patterns_array)

      Regexp.new string_regex_str
    end

    private

    # Cuts nearest to target, text from the start of the string
    def cut_nearest_text
      if @target.kind_of? Hash
        target_regex_str = "(?:#{@target.escape.join('|')})"
        text_regex_str = (1..@target_str.count).map do |step|
          all = step.eql?(1) ? '.' : '[\w\W]'
          add_to("#{all}+?", target_regex_str)
        end.join

        return @text[Regexp.new(add_to('(?:\n|\A|\Z)', text_regex_str))]
      end

      @text[text_regex_for_string, 1]
    end

    def text_regex_for_string
      {
        behind: /[\w\W]*((?:\n|\A)[\w\W]*?#{@title_str}\s*)#{@target.escape}/,
        ahead: /#{@target.escape}([\w\W]*?#{@title_str}(?:\n|\Z))/
      }[options[:look]]
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

    # Joins patterns by count, i.e. returns pattern with '+' (or chars count if
    # :strict_count true) instead array with a multiple identical patterns
    def join_patterns(array)
      array.map do |patterns|
        count = options[:strict_count] ? "{#{patterns.count}}" : '+'
        patterns.one? ? patterns.first : "#{patterns.first}#{count}"
      end.join
    end

    # Prepares options
    def options
      @options[:title] = @title

      if @options[:self_recognition].kind_of? String
        @options[:self_recognition] = @options[:self_recognition].chars
      end

      @options[:look] = @options[:look] ? @options[:look].to_sym : :behind
      unless %i[ahead behind].include? @options[:look]
        raise RegexGenerator::InvalidOption, :look
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

    # Adds target to source depending on source type and :look option, i.e. when
    # :look is :behind it adds target to the start of the source, otherwise adds
    # target to the end of the source
    def add_to(source, target)
      actions = { array: { behind: :push, ahead: :unshift },
                  string: { behind: :concat, ahead: :prepend } }
      action = actions[source.class.name.downcase.to_sym][options[:look]]

      source.public_send(action, target)
    end

    # Recognizes text depending on target type
    def recognize_text(text, options = {})
      unless @target.kind_of? Hash
        return add_to(recognize(text, options), "(#{target_patterns})")
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
