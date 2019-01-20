FactoryBot.define do
  factory :simple_text, class: String do
    argument { "The simple text\n  With number: 25.78" }
  end

  factory :simple_target, class: String do
    argument { '25.78' }
  end

  factory :simple_regex, class: Regexp do
    argument { /\n\s+[A-Z][a-z]+\s[a-z]+.\s(\d+\.\d+)/ }
  end

  factory :simple_regex_with_self_recognition_chars, class: Regexp do
    argument { /\n\s+[A-Z][a-z]+\s[a-z]+:\s(\d+\.\d+)/ }
  end

  factory :array_self_recognition_chars, class: Array do
    argument { %w[# % _ & :] }
  end

  factory :string_self_recognition_chars, class: String do
    argument { '#%_&:' }
  end

  factory :simple_regex_with_exact_target, class: Regexp do
    argument { /\n\s+[A-Z][a-z]+\s[a-z]+.\s(25\.78)/ }
  end

  factory :text_with_metacharacters, class: String do
    argument { '[Text], (with) {metacharacters}' }
  end

  factory :target_with_metacharacters, class: String do
    argument { '(with)' }
  end

  factory :regex_with_metacharacters, class: Regexp do
    argument { /\[[A-Z][a-z]+\].\s(\([a-z]+\))/ }
  end

  factory :unfound_target, class: String do
    argument { 'unfound_target' }
  end

  factory :multline_text, class: String do
    argument do
      %(Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque
        non scelerisque metus. Orci varius natoque penatibus et magnis dis
        parturient montes, nascetur ridiculus mus. Maecenas ac ligula vitae mi
        dignissim vulputate. Sed ac tincidunt purus. Duis tempus ultricies odio
        nec sollicitudin. Nam urna nibh, maximus quis urna a, laoreet tempus
        mauris. Suspendisse hendrerit dolor sit amet enim rhoncus sollicitudin.
        Vestibulum felis arcu, accumsan id lorem id, sodales egestas nunc.
        Vestibulum blandit sollicitudin condimentum. Nulla sed augue eget nunc
        vestibulum porttitor. Duis a sapien id nibh tristique convallis eu
        egestas nibh. Etiam sed ligula vel urna fermentum tincidunt vitae vitae
        risus)
    end
  end

  factory :target_for_multline_text, class: String do
    argument { 'Nulla sed augue' }
  end

  factory :regex_for_multline_text, class: Regexp do
    argument do
      '\n\s+[A-Z][a-z]+\s[a-z]+\s[a-z]+\s[a-z]+\.'\
        '\s([A-Z][a-z]+\s[a-z]+\s[a-z]+)'
    end
  end

  initialize_with { new(argument) }
end
