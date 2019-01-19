RSpec.shared_examples '#generate' do
  it 'generates regex correctly' do
    expect(generator.generate).to eq regex
  end

  it 'checks that regex matches target' do
    expect(text[regex, 1]).to eq target
  end
end

RSpec.describe RegexGenerator::Generator do
  let(:generator) { described_class.new(target, text) }

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
  end
end
