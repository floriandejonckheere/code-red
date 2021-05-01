# frozen_string_literal: true

RSpec.describe Relationships do
  subject(:task) { create(:task) }

  it "returns empty when it does not block tasks" do
    expect(task.blocks).to be_empty
  end

  it "returns a collection when it blocks tasks" do
    blocked_by = create(:task, graph: task.graph)

    create(:edge, graph: task.graph, from: task, type: "blocked_by", to: blocked_by)

    expect(task.blocked_by).to eq [blocked_by]
    expect(blocked_by.blocks).to eq [task]
  end
end
