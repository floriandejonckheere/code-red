# frozen_string_literal: true

class Graph < RedisGraph
  attr_reader :name

  def initialize(name:)
    @name = name

    super(name, { url: ENV.fetch("REDIS_URL", "redis://redis:6379/1") })
  end

  def tasks
    Array(query("MATCH (n:Task) RETURN n").resultset)
      &.map { |result| Task.new(result.first.reduce(&:merge).merge(graph: self)) }
  end

  def inspect
    "#<Graph name=#{name}>"
  end

  alias to_s inspect
end
