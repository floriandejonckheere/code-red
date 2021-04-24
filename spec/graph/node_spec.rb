# frozen_string_literal: true

RSpec.describe Node, type: :model do
  subject(:node) { build(:node) }

  it { is_expected.to validate_presence_of :graph }

  describe "#save" do
    it "assigns a random id" do
      node.save

      expect(node.id).not_to be_nil
    end
  end

  describe "#==" do
    it { is_expected.not_to eq OpenStruct.new(id: "foo") }
    it { is_expected.not_to eq build(:node) }
    it { is_expected.to eq build(:node, id: node.id) }
  end
end
