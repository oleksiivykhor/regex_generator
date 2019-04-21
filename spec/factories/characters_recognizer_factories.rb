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

  factory :hash_title, class: RegexGenerator::Target do
    argument { { first: 'first title', second: 'second title' } }
  end

  factory :chars_for_hash_title, class: Array do
    argument do
      ['[a-z]', '[a-z]', '[a-z]', '[a-z]', '\s', '\s', '\s', '\n', '\s',
       '\s', 'first title', '\s', '\s', '\s', '[a-z]', '[a-z]', '[a-z]',
       '[a-z]', '\s', '\s', '\n', '\s', '\s', '[a-z]', '[a-z]', '[a-z]',
       '[a-z]', '\s', 'second title', '\n', '\s', '[a-z]', '[a-z]', '[a-z]',
       '[a-z]']
    end
  end

  factory :string_title, class: RegexGenerator::Target do
    argument { 'some title' }
  end

  factory :chars_for_string_title, class: Array do
    argument do
      ['\n', '\s', '\s', '\s', '[a-z]', '[a-z]', '[a-z]', '[a-z]', '\s',
       '\s', 'some title', '\s', '\s', '[a-z]', '[a-z]', '[a-z]', '[a-z]']
    end
  end

  initialize_with { new(argument) }
end
