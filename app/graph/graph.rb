# frozen_string_literal: true

class Graph < RedisGraph
  attr_reader :name

  def initialize(name:)
    @name = name

    super(name, { url: ENV.fetch("REDIS_URL", "redis://redis:6379/1") })
  end

  def tasks
    match(:n, "Task")
      .return(:n)
      .map { |result| Task.load(result[:n].merge(graph: self)) }
  end

  def dsl
    DSL.new(self)
  end

  delegate :match, :merge, to: :dsl

  def inspect
    "#<Graph name=#{name}>"
  end

  alias to_s inspect
end
