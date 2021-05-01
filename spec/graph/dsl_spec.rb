# frozen_string_literal: true

RSpec.describe DSL do
  subject(:dsl) { build(:dsl) }

  let!(:node) { create(:node, graph: dsl.graph) }
  let!(:task0) { create(:task, graph: dsl.graph) }
  let!(:task1) { create(:task, graph: dsl.graph) }

  it "returns all nodes" do
    query = dsl
      .match(:n)
      .return(:n)

    expect(query.to_cypher).to eq "MATCH (n) RETURN n"
    expect(query.execute).to match_array [{ n: including(id: node.id) }, { n: including(id: task0.id) }, { n: including(id: task1.id) }]
  end

  it "returns nodes filtered on label" do
    query = dsl
      .match(:n, "Task")
      .return(:n)

    expect(query.to_cypher).to eq "MATCH (n:Task) RETURN n"
    expect(query.execute).to match_array [{ n: including(id: task0.id) }, { n: including(id: task1.id) }]
  end

  it "returns a node" do
    query = dsl
      .match(:n, "Task", id: task0.id)
      .return(:n)

    expect(query.to_cypher).to eq "MATCH (n:Task {id: '#{task0.id}'}) RETURN n"
    expect(query.execute).to match_array [n: including(id: task0.id, title: task0.title)]
  end

  # dsl.match(:n, "Task", id: task.id).delete(:n)
  # dsl.match(:n, "Task", id: task.id).merge(title: "My task")
  #
  # dsl
  #   .match(:n, "Task", id: task.id)
  #   .to(:r, "related_to")
  #   .match(:m, "Task", id: task.id)
  #   .return(:n, "type(r)", :m)
  #
  # dsl
  #   .match(:n, "Task", id: task.id)
  #   .to(:r, "related_to")
  #   .match(:m, "Task", id: task.id)
  #   .delete(:r)
  #
  # dsl
  #   .match(:n, "Task", id: task.id)
  #   .to(:r, "related_to")
  #   .match(:m, "Task", id: task.id)
  #   .merge()
end
