RSpec.shared_examples '#generate' do
  it 'generates regex correctly' do
    expect(generator.generate).to eq regex
  end

  it 'checks that regex matches target' do
    expect(text[regex, 1]).to eq target
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
  end
end
