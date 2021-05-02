# frozen_string_literal: true

class DSL
  attr_reader :graph, :clauses
  attr_accessor :names

  # Clause target for `.to` method (:match or :merge)
  attr_writer :target

  def initialize(graph)
    @graph = graph

    @clauses = {
      match: MatchClause.new,
      merge: MatchClause.new,
      return: ReturnClause.new,
      delete: Clause.new,
      set: Clause.new,
    }
    @names = Set.new
  end

  def match(name, label = nil, **attributes)
    names << name

    label = ":#{label}" if label
    attributes = " {#{attributes.map { |k, v| "#{k}: '#{v}'" }.join(', ')}}" if attributes.any?

    clauses[:match] << "(#{name}#{label.presence}#{attributes.presence})"

    # Set clause target
    self.target = :match

    self
  end

  def merge(name, label = nil, **attributes)
    names << name

    label = ":#{label}" if label
    attributes = " {#{attributes.map { |k, v| "#{k}: '#{v}'" }.join(', ')}}" if attributes.any?

    clauses[:merge] << "(#{name}#{label.presence}#{attributes.presence})"

    # Set clause target
    self.target = :merge

    self
  end

  def to(name, label = nil)
    label = ":#{label}" if label

    clauses[target] << "-[#{name}#{label}]->"

    self
  end

  def return(*names, **aliases)
    self.names += names
    clauses[:return] += names

    self.names += aliases.keys
    clauses[:return] += aliases.map { |k, v| "#{v} AS #{k}" }

    self
  end

  def delete(*names)
    self.names += names
    clauses[:delete] << names.join(", ")

    # TODO: return node when deleting

    self
  end

  def set(**attributes)
    clauses[:set] << names.flat_map { |n| attributes.map { |k, v| "#{n}.#{k} = '#{v}'" } }.join(", ")

    self
  end

  # rubocop:disable Metrics/AbcSize
  def execute
    Rails.logger.debug to_cypher

    result = graph
      .query(to_cypher)
      .resultset

    # TODO: check `stats` and return true/false
    return [] unless result

    result
      .map { |r| names.index_with.with_index { |_name, i| r[i].respond_to?(:each) ? r[i].reduce(&:merge).symbolize_keys : r[i] } }
  end
  # rubocop:enable Metrics/AbcSize

  def to_cypher
    clauses
      .filter_map { |k, v| "#{k.upcase} #{v.to_query}" if v.present? }
      .join(" ")
  end

  private

  def target
    @target || raise(ArgumentError, "method `to` without preceding `match` or `merge` not allowed")
  end

  # Simple clause: join elements with space
  class Clause < Array
    def to_query
      join(" ")
    end

    def +(other)
      self.class.new(super)
    end
  end

  # Match clause: join nodes with comma, and relationships between nodes with spaces:
  # [(n), (m)] => MATCH (n), (m)
  # [(n), -[r]->, (m)] => MATCH (n) -[r]-> (m)
  class MatchClause < Clause
    def to_query
      # Determine separators: if previous element ends with '>' or next element
      # starts with '-', use space as separator, otherwise use comma space
      separators = each_cons(2).map do |one, two|
        next " " if one.ends_with?(">") || two.starts_with?("-")

        ", "
      end

      # Zip query elements with separators and compact (because there are n - 1 separators)
      zip(separators).flatten.compact.join
    end
  end

  # Return clause: join nodes with comma
  class ReturnClause < Clause
    def to_query
      join(", ")
    end
  end
end
