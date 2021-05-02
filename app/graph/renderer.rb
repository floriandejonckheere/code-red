# frozen_string_literal: true

class Renderer
  attr_reader :graph

  def initialize(graph)
    @graph = graph
  end

  def to_h
    {
      nodes: nodes,
      edges: edges,
    }
  end

  private

  def nodes
    graph.tasks.map do |task|
      {
        id: task.id,
        label: task.title,
        x: 0,
        y: 0,
        size: 3,
      }
    end
  end

  def edges
    i = 0

    graph.tasks.flat_map do |task|
      task.relationships.select { |_k, v| v[:inverse_of].nil? }.keys.flat_map do |relationship_type|
        task.send(relationship_type).map do |node|
          {
            id: (i += 1),
            source: task.id,
            target: node.id,
            label: relationship_type.to_s.titleize,
          }
        end
      end
    end
  end
end
