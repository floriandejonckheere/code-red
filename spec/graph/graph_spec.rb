# frozen_string_literal: true

RSpec.describe Graph do
  subject(:graph) { build(:graph, name: "my_graph") }

  it "has a name" do
    expect(graph.name).to eq "my_graph"
  end

  describe "#tasks" do
    it "returns a list of tasks" do
      task = build(:task, graph: graph)

      expect(graph.tasks).to eq [task]
    end
  end
end
