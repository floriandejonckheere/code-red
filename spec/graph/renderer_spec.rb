# frozen_string_literal: true

RSpec.describe Renderer do
  subject(:renderer) { described_class.new(graph) }

  let(:graph) { build(:graph) }

  let!(:task0) { create(:task, graph: graph, type: "epic") }
  let!(:task1) { create(:task, graph: graph) }

  before { create(:edge, graph: graph, from: task0, type: "related_to", to: task1) }

  describe "nodes" do
    it "returns a list of nodes" do
      expect(renderer.to_h.fetch(:nodes))
        .to match_array [
          including(id: "root", label: graph.name),
          including(id: task0.id, label: task0.title),
          including(id: task1.id, label: task1.title),
        ]
    end
  end

  describe "edges" do
    it "returns a list of edges" do
      expect(renderer.to_h.fetch(:edges))
        .to match_array [
          including(source: 0, target: 1),
          including(source: 1, target: 2, label: "Related To"),
        ]
    end
  end
end
