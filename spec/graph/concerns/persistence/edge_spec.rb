# frozen_string_literal: true

RSpec.describe Persistence::Edge do
  subject(:edge) { build(:edge) }

  describe "#destroy" do
    it "destroys the edge and returns true" do
      edge.save

      expect(Edge.where(edge.graph, from: edge.from, type: edge.type, to: edge.to)).not_to be_empty

      expect(edge.destroy).to eq true

      expect(Edge.where(edge.graph, from: edge.from, type: edge.type, to: edge.to)).to be_empty
    end

    it "returns false if the edge was not destroyed" do
      expect(Edge.where(edge.graph, from: edge.from, type: edge.type, to: edge.to)).to be_empty

      expect(edge.destroy).to eq false

      expect(Edge.where(edge.graph, from: edge.from, type: edge.type, to: edge.to)).to be_empty
    end
  end

  describe "#destroyed?" do
    it "returns true if the edge was destroyed" do
      edge.save

      edge.destroy

      expect(edge).to be_destroyed
    end

    it "returns false if the edge was not destroyed" do
      edge.destroy

      expect(edge).not_to be_destroyed
    end
  end

  describe "#new_record?" do
    it "returns true if the record was not persisted yet" do
      expect(edge).to be_new_record
    end

    it "returns false if the record was persisted" do
      edge.save

      expect(edge).not_to be_new_record
    end
  end

  describe "#persisted?" do
    it "returns false if the record was not persisted yet" do
      expect(edge).not_to be_persisted
    end

    it "returns true if the record was persisted" do
      edge.save

      expect(edge).to be_persisted
    end

    it "returns false if the record was destroyed" do
      edge.save
      edge.destroy

      expect(edge).not_to be_persisted
    end
  end

  describe "#save" do
    it "persists the edge and returns true" do
      expect(Edge.where(edge.graph, from: edge.from, type: edge.type, to: edge.to)).to be_empty

      expect(edge.save).to eq true

      expect(Edge.where(edge.graph, from: edge.from, type: edge.type, to: edge.to)).not_to be_empty
    end

    it "returns false if the edge was not persisted" do
      type = edge.type
      expect(Edge.where(edge.graph, from: edge.from, type: type, to: edge.to)).to be_empty

      edge.type = nil
      expect(edge.save).to eq false

      expect(Edge.where(edge.graph, from: edge.from, type: type, to: edge.to)).to be_empty
    end
  end
end
