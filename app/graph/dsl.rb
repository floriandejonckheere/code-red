# frozen_string_literal: true

class DSL
  attr_reader :graph, :query
  attr_accessor :names

  def initialize(graph)
    @graph = graph

    @query = []
    @names = []
  end

  def match(name, label = nil, **attributes)
    label = ":#{label}" if label
    attributes = " {#{attributes.map { |k, v| "#{k}: '#{v}'" }.join(', ')}}" if attributes.any?

    query << "MATCH (#{name}#{label.presence}#{attributes.presence})"

    self
  end

  def to(name, label); end

  def return(*names)
    self.names += names
    query << "RETURN #{names.join(', ')}"

    self
  end

  def delete(*names)
    self.names += names
    query << "DELETE #{names.join(', ')}"

    self
  end

  def merge(**attributes); end

  def execute
    Rails.logger.debug to_cypher

    result = graph
      .query(to_cypher)
      .resultset

    return [] unless result

    result
      .map { |r| names.index_with.with_index { |_name, i| r[i].reduce(&:merge).symbolize_keys } }
  end

  def to_cypher
    query.join(" ")
  end
end