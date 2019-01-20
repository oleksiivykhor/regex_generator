FactoryBot.define do
  factory :simple_string, class: String do
    argument { 'The simple string' }
  end

  factory :simple_regex_chars, class: Array do
    argument do
      %w([A-Z] [a-z] [a-z] \s [a-z] [a-z] [a-z] [a-z] [a-z] [a-z] \s [a-z]
         [a-z] [a-z] [a-z] [a-z] [a-z])
    end
  end

  factory :string_with_metacharacters, class: String do
    argument { 'String [with] {metacharacters}$' }
  end

  factory :regex_chars_with_metacharacters, class: Array do
    argument do
      %w([A-Z] [a-z] [a-z] [a-z] [a-z] [a-z] \s \[ [a-z] [a-z] [a-z] [a-z] \]
         \s \{ [a-z] [a-z] [a-z] [a-z] [a-z] [a-z] [a-z] [a-z] [a-z] [a-z] [a-z]
         [a-z] [a-z] [a-z] \} \$)
    end
  end

  factory :string_with_extra_symbols, class: String do
    argument { 'String _ with # extra % symbols @@@' }
  end

  factory :regex_chars_with_extra_symbols, class: Array do
    argument do
      %w([A-Z] [a-z] [a-z] [a-z] [a-z] [a-z] \s _ \s [a-z] [a-z] [a-z] [a-z] \s
         \# \s [a-z] [a-z] [a-z] [a-z] [a-z] \s % \s [a-z] [a-z] [a-z] [a-z]
         [a-z] [a-z] [a-z] \s @ @ @)
    end
  end

  factory :extra_symbols_options, class: Array do
    argument { %w[_ # % @] }
  end

  initialize_with { new(argument) }
end
