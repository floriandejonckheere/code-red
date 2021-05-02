# frozen_string_literal: true

RSpec.describe DSL do
  subject(:dsl) { build(:dsl, graph: graph) }

  let(:graph) { build(:graph) }

  let!(:node) { create(:node, graph: graph) }
  let!(:task0) { create(:task, graph: graph) }
  let!(:task1) { create(:task, graph: graph) }

  describe "#return" do
    it "returns all nodes" do
      query = dsl
        .match(:n)
        .return(:n)

      expect(query.to_cypher).to eq "MATCH (n) RETURN n"
      expect(query.execute)
        .to match_array [
          { n: including(id: node.id) },
          { n: including(id: task0.id) },
          { n: including(id: task1.id) },
        ]
    end

    it "returns nodes filtered on label" do
      query = dsl
        .match(:n, "Task")
        .return(:n)

      expect(query.to_cypher).to eq "MATCH (n:Task) RETURN n"
      expect(query.execute)
        .to match_array [
          { n: including(id: task0.id) },
          { n: including(id: task1.id) },
        ]
    end

    it "returns a node" do
      query = dsl
        .match(:n, "Task", id: task0.id)
        .return(:n)

      expect(query.to_cypher).to eq "MATCH (n:Task {id: '#{task0.id}'}) RETURN n"
      expect(query.execute)
        .to match_array [
          n: including(id: task0.id, title: task0.title),
        ]
    end
  end

  describe "#delete" do
    it "deletes all nodes" do
      query = dsl
        .match(:n)
        .delete(:n)

      expect(query.to_cypher).to eq "MATCH (n) DELETE n"
      expect(query.execute).to be_empty

      expect(graph.dsl.match(:n).return(:n).execute).to be_empty
    end

    it "deletes nodes filtered on label" do
      query = dsl
        .match(:n, "Task")
        .delete(:n)

      expect(query.to_cypher).to eq "MATCH (n:Task) DELETE n"
      expect(query.execute).to be_empty

      expect(graph.dsl.match(:n).return(:n).execute)
        .to match_array [
          n: including(id: node.id),
        ]
    end

    it "deletes a node" do
      query = dsl
        .match(:n, "Task", id: task0.id)
        .delete(:n)

      expect(query.to_cypher).to eq "MATCH (n:Task {id: '#{task0.id}'}) DELETE n"
      expect(query.execute).to be_empty

      expect(graph.dsl.match(:n).return(:n).execute)
        .to match_array [
          { n: including(id: node.id) },
          { n: including(id: task1.id) },
        ]
    end
  end

  describe "#set" do
    it "sets properties on all nodes" do
      query = dsl
        .match(:n)
        .set(title: "New title")

      expect(query.to_cypher).to eq "MATCH (n) SET n.title = 'New title'"
      expect(query.execute).to be_empty

      expect(graph.dsl.match(:n).return(:n).execute)
        .to match_array [
          { n: including(id: node.id, title: "New title") },
          { n: including(id: task0.id, title: "New title") },
          { n: including(id: task1.id, title: "New title") },
        ]
    end

    it "sets properties on nodes filtered on label" do
      query = dsl
        .match(:n, "Task")
        .set(title: "New title")

      expect(query.to_cypher).to eq "MATCH (n:Task) SET n.title = 'New title'"
      expect(query.execute).to be_empty

      expect(graph.dsl.match(:n).return(:n).execute)
        .to match_array [
          { n: including(id: node.id) },
          { n: including(id: task0.id, title: "New title") },
          { n: including(id: task1.id, title: "New title") },
        ]
    end

    it "sets properties on a node" do
      query = dsl
        .match(:n, "Task", id: task0.id)
        .set(title: "New title")

      expect(query.to_cypher).to eq "MATCH (n:Task {id: '#{task0.id}'}) SET n.title = 'New title'"
      expect(query.execute).to be_empty

      expect(graph.dsl.match(:n).return(:n).execute)
        .to match_array [
          { n: including(id: node.id) },
          { n: including(id: task0.id, title: "New title") },
          { n: including(id: task1.id, title: task1.title) },
        ]
    end
  end

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
