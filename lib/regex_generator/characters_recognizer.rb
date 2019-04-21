module RegexGenerator
  class CharactersRecognizer
    class << self
      PATTERNS = [/[A-Z]/, /[a-z]/, /\d/, /\n/, /\s/, /./].freeze

      # Creates array with regex representation for each char from the text
      #
      # @param text [String]
      # @param options [Hash] options to recognize regex patterns with
      # @option options [Array] :self_recognition to recognize chars as itself
      # @option options [String, Hash] :title to recognize all chars excluding
      #   title
      # @return [Array]
      def recognize(text, options = {})
        return [] unless text

        result = []

        for_each_char(text, options) do |char, title|
          next result << title if title

          PATTERNS.each do |pattern|
            next unless char[pattern]

            escaped_char = Regexp.escape(char)
            res_pattern = escaped_char
            res_pattern = pattern.source if (char.eql?(escaped_char) &&
              !options[:self_recognition]&.include?(escaped_char)) || char[/\s/]

            break result << res_pattern
          end
        end

        result
      end

      private

      # Executes the block for each char in the text excluding the titles
      def for_each_char(text, options)
        title_regex = if options[:title].kind_of?(Hash)
          /(#{options[:title].escape.join('|')})/
        else
          /(#{options[:title]})/
        end

        text.split(title_regex).each do |txt|
          next if txt.empty?
          next yield(nil, txt) if txt[title_regex].eql?(txt)

          txt.chars.each { |char| yield char, nil }
        end
      end
    end
  end
end
