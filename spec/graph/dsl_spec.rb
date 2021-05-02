# frozen_string_literal: true

RSpec.describe DSL do
  subject(:dsl) { build(:dsl, graph: graph) }

  let(:graph) { build(:graph) }

  let!(:node) { create(:node, graph: graph) }
  let!(:task0) { create(:task, graph: graph) }
  let!(:task1) { create(:task, graph: graph) }

  before { create(:edge, graph: graph, from: task0, type: "related_to", to: task1) }

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
      expect(query)
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
      expect(query)
        .to match_array [
          n: including(id: task0.id, title: task0.title),
        ]
    end

    it "returns multiple nodes" do
      query = dsl
        .match(:n, "Task", id: task0.id)
        .match(:m, "Task", id: task1.id)
        .return(:n, :m)

      expect(query.to_cypher).to eq "MATCH (n:Task {id: '#{task0.id}'}), (m:Task {id: '#{task1.id}'}) RETURN n, m"
      expect(query)
        .to match_array [
          {
            n: including(id: task0.id),
            m: including(id: task1.id),
          },
        ]
    end

    it "returns a node's relationships" do
      query = dsl
        .match(:n, "Task", id: task0.id)
        .to(:r, "related_to")
        .match(:m)
        .return(:n, :m, t: "type(r)")

      expect(query.to_cypher).to eq "MATCH (n:Task {id: '#{task0.id}'}) -[r:related_to]-> (m) RETURN n, m, type(r) AS t"
      expect(query)
        .to match_array [
          {
            n: including(id: task0.id),
            t: "related_to",
            m: including(id: task1.id),
          },
        ]
    end
  end

  describe "#delete" do
    it "deletes all nodes" do
      query = dsl
        .match(:n)
        .delete(:n)

      expect(query.to_cypher).to eq "MATCH (n) DELETE n"
      expect(query).to be_empty

      expect(graph.dsl.match(:n).return(:n)).to be_empty
    end

    it "deletes nodes filtered on label" do
      query = dsl
        .match(:n, "Task")
        .delete(:n)

      expect(query.to_cypher).to eq "MATCH (n:Task) DELETE n"
      expect(query).to be_empty

      expect(graph.dsl.match(:n).return(:n))
        .to match_array [
          n: including(id: node.id),
        ]
    end

    it "deletes a node" do
      query = dsl
        .match(:n, "Task", id: task0.id)
        .delete(:n)

      expect(query.to_cypher).to eq "MATCH (n:Task {id: '#{task0.id}'}) DELETE n"
      expect(query).to be_empty

      expect(graph.dsl.match(:n).return(:n))
        .to match_array [
          { n: including(id: node.id) },
          { n: including(id: task1.id) },
        ]
    end

    it "deletes a node's relationships" do
      query = dsl
        .match(:n, "Task", id: task0.id)
        .to(:r, "related_to")
        .match(:m)
        .delete(:r)

      expect(query.to_cypher).to eq "MATCH (n:Task {id: '#{task0.id}'}) -[r:related_to]-> (m) DELETE r"
      expect(query).to be_empty

      expect(graph.dsl.match(:n, "Task", id: task0.id).to(:r, "related_to").match(:m).return(:n, :m, t: "type(r)")).to be_empty
    end
  end

  describe "#set" do
    it "sets properties on all nodes" do
      query = dsl
        .match(:n)
        .set(title: "New title")

      expect(query.to_cypher).to eq "MATCH (n) SET n.title = 'New title'"
      expect(query).to be_empty

      expect(graph.dsl.match(:n).return(:n))
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
      expect(query).to be_empty

      expect(graph.dsl.match(:n).return(:n))
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
      expect(query).to be_empty

      expect(graph.dsl.match(:n).return(:n))
        .to match_array [
          { n: including(id: node.id) },
          { n: including(id: task0.id, title: "New title") },
          { n: including(id: task1.id, title: task1.title) },
        ]
    end
  end

  describe "#merge" do
    it "creates a node if it does not exist" do
      query = dsl
        .merge(:n, "Task", id: "new_id")
        .set(title: "New title")

      expect(query.to_cypher).to eq "MERGE (n:Task {id: 'new_id'}) SET n.title = 'New title'"
      expect(query).to be_empty

      expect(graph.dsl.match(:n).return(:n))
        .to match_array [
          { n: including(id: node.id) },
          { n: including(id: task0.id, title: task0.title) },
          { n: including(id: task1.id, title: task1.title) },
          { n: including(id: "new_id", title: "New title") },
        ]
    end

    it "merges a node if it exists" do
      query = dsl
        .merge(:n, "Task", id: task0.id)
        .set(title: "New title")

      expect(query.to_cypher).to eq "MERGE (n:Task {id: '#{task0.id}'}) SET n.title = 'New title'"
      expect(query).to be_empty

      expect(graph.dsl.match(:n).return(:n))
        .to match_array [
          { n: including(id: node.id) },
          { n: including(id: task0.id, title: "New title") },
          { n: including(id: task1.id, title: task1.title) },
        ]
    end

    it "merges a relationship if it does not exist" do
      query = dsl
        .match(:n, "Task", id: task0.id)
        .match(:m, "Node", id: node.id)
        .merge(:n)
        .to(:r, "related_to")
        .merge(:m)

      expect(query.to_cypher).to eq "MATCH (n:Task {id: '#{task0.id}'}), (m:Node {id: '#{node.id}'}) MERGE (n) -[r:related_to]-> (m)"
      expect(query).to be_empty

      expect(graph.dsl.match(:n, "Task", id: task0.id).to(:r, "related_to").match(:m, "Node").return(:n, :m, t: "type(r)"))
        .to match_array [
          {
            n: including(id: task0.id),
            t: "related_to",
            m: including(id: node.id),
          },
        ]
    end
  end
end
