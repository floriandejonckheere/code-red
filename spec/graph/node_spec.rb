# frozen_string_literal: true

RSpec.describe Node, type: :model do
  subject(:node) { build(:node) }

  it { is_expected.to validate_presence_of :graph }

  describe ".find" do
    it "finds the node by id" do
      node.save

      expect(described_class.find(node.graph, node.id)).to eq node
    end
  end
end
