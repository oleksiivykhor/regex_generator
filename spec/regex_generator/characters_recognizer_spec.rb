RSpec.shared_examples '.recognize' do
  it 'recognize characters correctly' do
    expect(described_class.recognize(string, options)).to eq result
  end
end

RSpec.describe RegexGenerator::CharactersRecognizer do
  describe '.recognize' do
    let(:options) { {} }
    let(:string) { build(:simple_string) }
    let(:result) { build(:simple_regex_chars) }

    it_behaves_like '.recognize'

    context 'when string contains metacharacters' do
      let(:string) { build(:string_with_metacharacters) }
      let(:result) { build(:regex_chars_with_metacharacters) }

      it_behaves_like '.recognize'
    end

    context 'when nil is given instead of string' do
      let(:string) { nil }
      let(:result) { [] }

      it_behaves_like '.recognize'
    end

    context 'when options[:self_recognition] is given' do
      let(:options) { { self_recognition: build(:extra_symbols_options) } }
      let(:string) { build(:string_with_extra_symbols) }
      let(:result) { build(:regex_chars_with_extra_symbols) }

      it_behaves_like '.recognize'
    end
  end
end
