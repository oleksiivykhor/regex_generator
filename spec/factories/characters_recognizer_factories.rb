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

  initialize_with { new(argument) }
end
