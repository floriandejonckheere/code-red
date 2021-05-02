# frozen_string_literal: true

class DSL
  attr_reader :graph, :query
  attr_accessor :names

  def initialize(graph)
    @graph = graph

    @query = []
    @names = Set.new
  end

  def match(name, label = nil, **attributes)
    names << name

    label = ":#{label}" if label
    attributes = " {#{attributes.map { |k, v| "#{k}: '#{v}'" }.join(', ')}}" if attributes.any?

    query << "MATCH (#{name}#{label.presence}#{attributes.presence})"

    self
  end

  def merge(name, label = nil, **attributes)
    names << name

    label = ":#{label}" if label
    attributes = " {#{attributes.map { |k, v| "#{k}: '#{v}'" }.join(', ')}}" if attributes.any?

    query << "MERGE (#{name}#{label.presence}#{attributes.presence})"

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

    # TODO: return node when deleting

    self
  end

  def set(**attributes)
    query << "SET #{names.flat_map { |n| attributes.map { |k, v| "#{n}.#{k} = '#{v}'" } }.join(', ')}"

    self
  end

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
