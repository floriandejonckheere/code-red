# frozen_string_literal: true

RSpec.describe Persistence::Node do
  subject(:node) { build(:node) }

  describe "#destroy" do
    it "destroys the node and returns true" do
      node.save

      expect(Node.find(node.graph, node.id)).not_to be_nil

      expect(node.destroy).to eq true

      expect(Node.find(node.graph, node.id)).to be_nil
    end

    it "returns false if the node was not destroyed" do
      expect(Node.find(node.graph, node.id)).to be_nil

      expect(node.destroy).to eq false

      expect(Node.find(node.graph, node.id)).to be_nil
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

      expect(node).not_to be_destroyed
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
    it "returns false if the record was not persisted yet" do
      expect(node).not_to be_persisted
    end

    it "returns true if the record was persisted" do
      node.save

      expect(node).to be_persisted
    end

    it "returns false if the record was destroyed" do
      node.save
      node.destroy

      expect(node).not_to be_persisted
    end
  end

  describe "#reload" do
    it "reloads the attributes" do
      node.save
      node.created_at = nil

      node.reload
      expect(node.created_at).not_to be_nil
    end
  end

  describe "#save" do
    it "assigns a random id" do
      expect(node.id).to be_nil

      node.save

      expect(node.id).not_to be_nil
    end

    it "persists the node and returns true" do
      expect(Node.find(node.graph, node.id)).to be_nil

      expect(node.save).to eq true

      expect(Node.find(node.graph, node.id)).not_to be_nil
    end

    xit "returns false if the node was not persisted"
  end

  describe "#update" do
    xit "updates the attributes and returns true"

    xit "returns false if the node was not persisted"
  end

  describe ".find" do
    it "finds the node by id" do
      node.save

      found = Node.find(node.graph, node.id)

      expect(found).to eq node
      expect(found).to be_persisted
    end
  end
end
