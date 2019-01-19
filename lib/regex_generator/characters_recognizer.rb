module RegexGenerator
  class CharactersRecognizer
    PATTERNS = [/[A-Z]/, /[a-z]/, /\d/, /\n/, /\s/, /./].freeze

    # Creates array with regex representation for each char from the text
    #
    # @param text [String]
    # @return [Array]
    def self.recognize(text)
      return [] unless text

      result = []
      text.chars.each do |char|
        PATTERNS.each do |pattern|
          next unless char[pattern]

          escaped_char = Regexp.escape(char)
          res_pattern = escaped_char
          res_pattern = pattern.source if char.eql?(escaped_char) || char[/\s/]
          break result << res_pattern
        end
      end

      result
    end
  end
end
