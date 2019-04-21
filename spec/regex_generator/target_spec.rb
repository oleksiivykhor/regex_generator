RSpec.describe RegexGenerator::Target do
  let(:target_instance) { described_class.new(target) }

  describe '#present?' do
    let(:text) { build(:simple_text) }

    context 'when target is present in the text' do
      let(:target) { build(:simple_target) }

      it { expect(target_instance).to be_present(text) }
    end

    context 'when target is not present in the text' do
      let(:target) { build(:unfound_target) }

      it { expect(target_instance).not_to be_present(text) }
    end

    context 'when target is a hash' do
      let(:text) { build(:text_with_multiple_targets) }
      let(:multline_text) { build(:multline_text) }
      let(:target) { build(:targets_hash) }

      it 'returns true when target is present in the text' do
        expect(target_instance).to be_present(text)
      end

      it 'returns false when target is not present in the text' do
        expect(target_instance).not_to be_present(multline_text)
      end
    end
  end

  describe '#to_s' do
    context 'when target is a string' do
      let(:target) { build(:simple_target) }

      it { expect(target_instance.to_s).to eq target }
    end

    context 'when target is a float' do
      let(:target) { 23.4 }
      let(:result) { '23.4' }

      it { expect(target_instance.to_s).to eq result }
    end

    context 'when target is a hash' do
      let(:target) { build(:simple_hash_target) }
      let(:result) { { target: '25.78' } }

      it { expect(target_instance.to_s).to eq result }
    end
  end

  describe '#kind_of?' do
    context 'when target is a string' do
      let(:target) { build(:simple_target) }

      it { expect(target_instance).to be_a String }
      it { expect(target_instance).not_to be_a Hash }
    end

    context 'when target is a float' do
      let(:target) { 23.4 }

      it { expect(target_instance).to be_a String }
      it { expect(target_instance).not_to be_a Float }
    end

    context 'when target is a hash' do
      let(:target) { build(:targets_hash) }

      it { expect(target_instance).to be_a Hash }
      it { expect(target_instance).not_to be_a String }
    end
  end

  describe '#escape' do
    let(:result) { '25\\.78' }

    context 'when target is a string' do
      let(:target) { build(:simple_target) }

      it { expect(target_instance.escape).to eq result }
    end

    context 'when target is a hash' do
      let(:target) { build(:simple_hash_target) }
      let(:hash_result) { { target: '25\\.78' } }

      it { expect(target_instance.escape).to eq [result] }
      it { expect(target_instance.escape(keys: true)).to eq hash_result }
    end
  end

  describe '#keys_equal?' do
    let(:target) { 'Some title' }
    let(:second_target_instance) { described_class.new(second_target) }

    context 'when both objects has a different type' do
      let(:second_target) { build(:targets_hash) }

      it { expect(target_instance).not_to be_keys_equal second_target_instance }
    end

    context 'when both objects are strings' do
      let(:second_target) { 'second target' }

      it { expect(target_instance).to be_keys_equal second_target_instance }
    end

    context 'when both objects are hashes with different keys' do
      let(:target) { build(:simple_hash_target) }
      let(:second_target) { build(:targets_hash) }

      it { expect(target_instance).not_to be_keys_equal second_target_instance }
    end

    context 'when both objects are hashes with the same keys' do
      let(:target) { build(:targets_hash) }
      let(:second_target) { target }

      it { expect(target_instance).to be_keys_equal second_target_instance }
    end
  end
end
