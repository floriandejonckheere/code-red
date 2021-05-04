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

  describe ".invert" do
    it "inverts if the relationship has an inverse" do
      Task.invert(from: "from", type: :blocks, to: "to") in { from: from, type: type, to: to }

      expect(from).to eq "to"
      expect(type).to eq :blocked_by
      expect(to).to eq "from"
    end

    it "does not invert if the relationship does not have an inverse" do
      Task.invert(from: "from", type: :blocked_by, to: "to") in { from: from, type: type, to: to }

      expect(from).to eq "from"
      expect(type).to eq :blocked_by
      expect(to).to eq "to"
    end
  end
end
