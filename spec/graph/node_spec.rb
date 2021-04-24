# frozen_string_literal: true

RSpec.describe Node do
  subject(:node) { build(:node) }

  it { is_expected.to validate_presence_of :graph }

  describe "#save" do
    it "assigns a random id" do
      node.save

      expect(node.id).not_to be_nil
    end
  end
end
