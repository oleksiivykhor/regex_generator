RSpec.shared_examples '.recognize' do
  it 'recognize characters correctly' do
    expect(described_class.recognize(string)).to eq result
  end
end

RSpec.describe RegexGenerator::CharactersRecognizer do
  describe '.recognize' do
    let(:string) { build(:simple_string) }
    let(:result) { build(:simple_regex_chars) }

    it_behaves_like '.recognize'

    context 'when string contains metacharacters' do
      let(:string) { build(:string_with_metacharacters) }
      let(:result) { build(:regex_chars_with_metacharacters) }

      it_behaves_like '.recognize'
    end
  end
end
