# frozen_string_literal: true

module Persistence
  module Edge
    extend ActiveSupport::Concern

    included do
      define_model_callbacks :destroy, :save

      def destroy
        run_callbacks :destroy do
          return false unless !destroyed? && persisted?

          graph
            .query("MATCH (n:#{from.class.name} {id: '#{from.id}'}) -[r:#{type}]-> (m:#{to.class.name}) DELETE r")

          @_destroyed = true
          @_persisted = false

          freeze

          true
        end
      end

      def destroyed?
        !!@_destroyed
      end

      def new_record?
        !persisted?
      end

      def persisted?
        !!@_persisted
      end

      def persist!
        @_persisted = true
      end

      def save
        run_callbacks :save do
          return false unless valid?

          graph
            .query("MATCH (n:#{from.class.name} {id: '#{from.id}'}) MATCH (m:#{to.class.name} {id: '#{to.id}'}) MERGE (n)-[r:#{type}]->(m)")

          @_persisted = true
        end
      end

      def ==(other)
        other.instance_of?(self.class) &&
          persisted? &&
          type == other.type &&
          to == other.to &&
          from == other.from
      end
    end

    class_methods do
      def load(...)
        new(...).tap(&:persist!)
      end

      # rubocop:disable Metrics/AbcSize
      def where(graph, from: nil, type: nil, to: nil)
        n_id = "{id: '#{from.id}'}" if from.id
        n = "(n:#{from.class.name} #{n_id})"

        m_id = "{id: '#{to.id}'}" if to.id
        m = "(m:#{to.class.name} #{m_id})"

        graph
          .query("MATCH #{n}-[r:#{type}]->#{m} RETURN n, type(r), m")
          .resultset
          .map do |result|
          from = from.class.load(result[0].reduce(&:merge).merge(graph: graph))
          type = result[1]
          to = to.class.load(result[2].reduce(&:merge).merge(graph: graph))

          load(graph: graph, from: from, type: type, to: to)
        end
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
