# frozen_string_literal: true

RSpec.describe Timestamps do
  subject(:node) { build(:node) }

  describe "#created_at" do
    it "is empty when object has not been persisted" do
      expect(node.created_at).to be_nil
    end

    it "is set when object was persisted" do
      node.save

      expect(node.created_at).not_to be_nil
    end
  end

  describe "#updated_at" do
    it "is empty when object has not been persisted" do
      expect(node.updated_at).to be_nil
    end

    it "is set when object was persisted" do
      node.save

      expect(node.updated_at).not_to be_nil
    end
  end
end
