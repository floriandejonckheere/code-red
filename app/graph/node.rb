# frozen_string_literal: true

class Node
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  include Persistence
  include Timestamps

  attribute :graph
  attribute :id, :string

  validates :graph,
            presence: true

  def inspect
    "#<#{self.class.name} #{attributes.compact.map { |k, v| [k, v].join('=') }.join(' ')}>"
  end

  def self.find(graph, id)
    properties = graph
      .query("MATCH (n:#{name} {id: '#{id}'}) RETURN n")
      .resultset
      .first
      &.first
      &.reduce(&:merge)
      &.merge(graph: graph)

    new(properties) if properties
  end
end
