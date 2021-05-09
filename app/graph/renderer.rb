# frozen_string_literal: true

class Renderer
  include TaskHelper

  attr_reader :graph

  def initialize(graph)
    @graph = graph
  end

  def to_h
    {
      nodes: nodes,
      edges: edges,
      groups: groups,
      constraints: constraints,
    }
  end

  private

  def nodes
    @nodes ||= tasks_by_type.values.flatten.map do |task|
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
    @edges ||= tasks.flat_map do |task|
      task.relationships.select { |_k, v| v[:inverse_of].nil? }.keys.flat_map do |relationship_type|
        task.send(relationship_type).map do |node|
          {
            source: nodes.find_index { |n| n[:id] == task.id },
            target: nodes.find_index { |n| n[:id] == node.id },
            label: relationship_type.to_s.titleize,
          }
        end
      end.reject(&:blank?)
    end
  end

  def groups
    @groups ||= tasks_by_type.fetch("feature", []).filter_map do |task|
      children = task.parent_of.map { |n| tasks.index(n) }

      { leaves: children } if children.present?
    end
  end

  def constraints
    @constraints ||= tasks_by_type.each_cons(2).flat_map do |(_type, nodes), (_subtype, subnodes)|
      nodes.flat_map do |node|
        subnodes.map do |subnode|
          {
            axis: "y",
            left: tasks.index(node),
            right: tasks.index(subnode),
            gap: 150,
          }
        end
      end
    end
  end

  def icon_for(type)
    # Extract <path> from SVG icon
    Heroicon::Icon
      .render(name: icon_for_type(type), variant: :outline, options: {})
      .at("path")
      .to_s
  end

  def tasks_by_type
    @tasks_by_type ||= graph
      .tasks
      .group_by(&:type)
      .sort_by { |k, _v| Task::TYPES.index(k) }
      .to_h
  end

  def tasks
    @tasks ||= tasks_by_type
      .values
      .flatten
  end
end
