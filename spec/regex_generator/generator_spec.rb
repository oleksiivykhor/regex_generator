RSpec.shared_examples '#generate' do
  it 'generates regex correctly' do
    expect(generator.generate).to eq regex
  end

  it 'checks that regex matches target' do
    if target.is_a? Hash
      target.each do |key, value|
        expect(text[regex, key]).to eq value.to_s
      end
    else
      expect(text[regex, 1]).to eq target.to_s
    end
  end
end

RSpec.describe RegexGenerator::Generator do
  let(:options) { {} }
  let(:generator) { described_class.new(target, text, options) }

  describe '#generate' do
    let(:target) { build(:simple_target) }
    let(:text) { build(:simple_text) }
    let(:regex) { build(:simple_regex) }

    it_behaves_like '#generate'

    context 'when text and target has metacharacters' do
      let(:target) { build(:target_with_metacharacters) }
      let(:text) { build(:text_with_metacharacters) }
      let(:regex) { build(:regex_with_metacharacters) }

      it_behaves_like '#generate'
    end

    context 'when target was not found in text' do
      let(:target) { build(:unfound_target) }

      it 'raises TargetNotFoundError' do
        expect { generator.generate }.
          to raise_error RegexGenerator::TargetNotFoundError
      end
    end

    context 'when target is a Hash and it is not present in the text' do
      let(:target) { build(:unfound_targets_hash) }

      it 'raises TargetNotFoundError' do
        expect { generator.generate }.
          to raise_error RegexGenerator::TargetNotFoundError
      end
    end

    context 'when multline text provided' do
      let(:target) { build(:target_for_multline_text) }
      let(:text) { build(:multline_text) }
      let(:regex) { build(:regex_for_multline_text) }

      it_behaves_like '#generate'
    end

    context 'when options[:exact_target] is given' do
      let(:options) { { exact_target: true } }
      let(:regex) { build(:simple_regex_with_exact_target) }

      it_behaves_like '#generate'
    end

    context 'when text is equal to target' do
      let(:text) { target }
      let(:regex) { /(\d+\.\d+)/ }

      it_behaves_like '#generate'
    end

    context 'when options[:self_recognition] is given as Array' do
      let(:options) do
        { self_recognition: build(:array_self_recognition_chars) }
      end
      let(:regex) { build(:simple_regex_with_self_recognition_chars) }

      it_behaves_like '#generate'
    end

    context 'when options[:self_recognition] is given as String' do
      let(:options) do
        { self_recognition: build(:string_self_recognition_chars) }
      end
      let(:regex) { build(:simple_regex_with_self_recognition_chars) }

      it_behaves_like '#generate'
    end

    context 'when target is given as hash with named targets' do
      let(:target) { build(:targets_hash) }
      let(:text) { build(:text_with_multiple_targets) }
      let(:regex) { build(:regex_with_named_groups) }

      it_behaves_like '#generate'
    end

    context 'when target is given as hash with named targets '\
      'and options[:exact_value] is given' do
      let(:options) { { exact_target: true } }
      let(:target) { build(:targets_hash) }
      let(:text) { build(:text_with_multiple_targets) }
      let(:regex) { build(:regex_with_named_groups_and_exact_targets) }

      it_behaves_like '#generate'
    end

    context 'when target is given as non string' do
      let(:target) { 25.78 }

      it_behaves_like '#generate'
    end

    context 'when target is given as hash with non string arguments' do
      let(:target) { build(:simple_hash_target) }
      let(:regex) { build(:simple_regex_with_named_capturing_group) }

      it_behaves_like '#generate'
    end

    context 'when target contains :self_recognition chars' do
      let(:options) { { self_recognition: %w[8 7 5 2] } }
      let(:regex) { build(:simple_regex_with_exact_target) }
      let(:target) { build(:simple_target) }

      it_behaves_like '#generate'
    end

    context 'when invalid options[:look] is given' do
      let(:options) { { look: :invalid } }

      it 'raises InvalidOption' do
        expect { generator.generate }.
          to raise_error RegexGenerator::InvalidOption
      end
    end

    context 'when option look: :ahead and target is a string' do
      let(:options) { { look: :ahead } }
      let(:regex) { build(:simple_ahead_regex) }
      let(:text) { build(:text_around_the_target) }

      it_behaves_like '#generate'
    end

    context 'when option look: :ahead and target is a hash' do
      let(:options) { { look: :ahead } }
      let(:regex) { build(:ahead_regex_with_named_capturing_group) }
      let(:text) { build(:text_around_the_target) }
      let(:target) { build(:simple_hash_target) }

      it_behaves_like '#generate'
    end
  end
end
