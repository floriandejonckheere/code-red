# frozen_string_literal: true

class Renderer
  attr_reader :graph, :edge_id

  def initialize(graph)
    @graph = graph
    @edge_id = 0
  end

  def to_h
    {
      nodes: [root_node] + nodes,
      edges: root_edges + edges,
    }
  end

  private

  def nodes
    graph.tasks.map do |task|
      {
        id: task.id,
        label: task.title,
        x: rand(0..10),
        y: rand(0..10),
        size: 3,
      }
    end
  end

  def edges
    graph.tasks.flat_map do |task|
      task.relationships.select { |_k, v| v[:inverse_of].nil? }.keys.flat_map do |relationship_type|
        task.send(relationship_type).map do |node|
          {
            id: (@edge_id += 1),
            source: task.id,
            target: node.id,
            label: relationship_type.to_s.titleize,
          }
        end
      end
    end
  end

  def root_node
    {
      id: "root",
      label: graph.name,
      x: 0,
      y: 0,
      size: 3,
    }
  end

  def root_edges
    graph.tasks.select { |t| t.type == "epic" }.map do |task|
      {
        id: (@edge_id += 1),
        source: "root",
        target: task.id,
      }
    end
  end
end
