# frozen_string_literal: true

RSpec.describe Renderer do
  subject(:renderer) { described_class.new(project) }

  let(:project) { create(:project) }

  let!(:task0) { create(:task, graph: project.graph, type: "epic") }
  let!(:task1) { create(:task, graph: project.graph, type: "task") }

  before { create(:edge, graph: project.graph, from: task0, type: "related_to", to: task1) }

  describe "nodes" do
    it "returns a list of nodes" do
      expect(renderer.to_h.fetch(:nodes))
        .to match_array [
          including(id: task0.id, label: task0.title),
          including(id: task1.id, label: task1.title),
        ]
    end
  end

  describe "edges" do
    it "returns a list of edges" do
      expect(renderer.to_h.fetch(:edges))
        .to match_array [
          including(source: 0, target: 1, label: "Related To"),
        ]
    end
  end
end
