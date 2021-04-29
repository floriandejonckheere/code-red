# frozen_string_literal: true

RSpec.describe Node do
  subject(:node) { build(:node) }

  describe "#destroy" do
    it "destroys the node and returns true" do
      node.save

      expect(described_class.find(node.id)).not_to be_nil

      expect(node.destroy).to eq true

      expect(described_class.find(node.id)).to be_nil
    end

    it "returns false if the node was not destroyed" do
      expect(described_class.find(node.id)).to be_nil

      expect(node.destroy).to eq false

      expect(described_class.find(node.id)).to be_nil
    end
  end

  describe "#destroyed?" do
    it "returns true if the node was destroyed" do
      node.save

      node.destroy

      expect(node).to be_destroyed
    end

    it "returns false if the node was not destroyed" do
      node.destroy

      expect(node).to be_destroyed
    end
  end

  describe "#new_record?" do
    it "returns true if the record was not persisted yet" do
      expect(node).to be_new_record
    end

    it "returns false if the record was persisted" do
      node.save

      expect(node).not_to be_new_record
    end
  end

  describe "#persisted?" do
    it "returns true if the record was not persisted yet" do
      expect(node).to be_persisted
    end

    it "returns false if the record was persisted" do
      node.save

      expect(node).not_to be_persisted
    end

    it "returns false if the record was destroyed" do
      node.save
      node.delete

      expect(node).not_to be_persisted
    end
  end

  describe "#reload" do
    xit "reloads the attributes"
  end

  describe "#save" do
    it "assigns a random id" do
      expect(node.id).to be_nil

      node.save

      expect(node.id).not_to be_nil
    end

    it "persists the node and returns true" do
      expect(described_class.find(node.id)).to be_nil

      expect(node.save).to eq true

      expect(described_class.find(node.id)).not_to be_nil
    end

    xit "returns false if the node was not persisted"
  end

  describe "#update" do
    xit "updates the attributes and returns true"

    xit "returns false if the node was not persisted"
  end

  describe "#==" do
    it "returns false when other is not a node" do
      expect(node).not_to eq OpenStruct.new
    end

    it "returns false when it is not persisted" do
      expect(node).not_to eq build(:node)
    end

    it "returns false when id is not equal" do
      node.save

      expect(node).not_to eq create(:node)
    end

    it "returns true when it is equal" do
      node.save

      expect(node).to eq node
    end
  end
end
