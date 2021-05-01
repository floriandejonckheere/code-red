# frozen_string_literal: true

RSpec.describe DSL do
  subject(:dsl) { build(:dsl) }

  let(:task) { create(:task, graph: dsl.graph) }

  it "returns a node" do
    query = dsl
      .match(:n, "Task", id: task.id)
      .return(:n)

    expect(query.to_cypher).to eq "MATCH (n:Task {id: '#{task.id}'}) RETURN n"
    expect(query.execute).to match_array [n: including(id: task.id, title: task.title)]
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
