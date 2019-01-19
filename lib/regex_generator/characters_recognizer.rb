module RegexGenerator
  class CharactersRecognizer
    PATTERNS = [/[A-Z]/, /[a-z]/, /\d/, /\n/, /\s/, /./].freeze

    def self.recognize(text)
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
