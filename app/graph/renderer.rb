# frozen_string_literal: true

class Renderer
  include TaskHelper

  attr_reader :graph

  def initialize(graph)
    @graph = graph
  end

  def to_h
    {
      nodes: [root_node] + nodes,
      edges: root_edges + edges,
    }
  end

  private

  def nodes
    @nodes ||= graph.tasks.map do |task|
      {
        id: task.id,
        label: task.title,
        icon: icon_for(task.type),
        color: color_for_type(task.type),
        type: task.type.titleize,
      }
    end
  end

  def edges
    @edges ||= graph.tasks.flat_map do |task|
      task.relationships.select { |_k, v| v[:inverse_of].nil? }.keys.flat_map do |relationship_type|
        task.send(relationship_type).map do |node|
          {
            source: nodes.find_index { |n| n[:id] == task.id } + 1,
            target: nodes.find_index { |n| n[:id] == node.id } + 1,
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
      icon: nil,
    }
  end

  def root_edges
    graph.tasks.select { |t| t.type == "epic" }.map do |task|
      {
        source: 0,
        target: nodes.find_index { |n| n[:id] == task.id } + 1,
      }
    end
  end

  def icon_for(type)
    # Extract <path> from SVG icon
    Heroicon::Icon
      .render(name: icon_for_type(type), variant: :outline, options: {})
      .at("path")
      .to_s
  end
end
