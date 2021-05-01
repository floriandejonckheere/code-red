# frozen_string_literal: true

module Persistence
  module Node
    extend ActiveSupport::Concern

    included do
      define_model_callbacks :destroy, :save

      def destroy
        run_callbacks :destroy do
          return false unless !destroyed? && (persisted? || !id.nil?)

          graph
            .query("MATCH (n:#{self.class.name} {id: '#{id}'}) DELETE n")

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
        id.nil?
      end

      def persisted?
        !!@_persisted
      end

      def persist!
        @_persisted = true
      end

      def reload
        return false unless persisted?

        graph
          .query("MATCH (n:#{self.class.name} {id: '#{id}'} RETURN n")
          .resultset
          .first
          &.first
          &.reduce(:merge)
          &.tap { |attributes| assign_attributes(attributes) }

        true
      end

      def save
        run_callbacks :save do
          return false unless valid?

          self.id ||= SecureRandom.uuid

          properties = attributes
            .except(:graph)
            .map { |k, v| "n.#{k} = '#{v}'" }
            .join(", ")

          graph
            .query("MERGE (n:#{self.class.name} {id: '#{id}'}) SET #{properties}")

          @_persisted = true
        end
      end

      def update(attributes)
        assign_attributes(attributes)

        save
      end

      def ==(other)
        other.instance_of?(self.class) &&
          persisted? &&
          other.id == id
      end
    end

    class_methods do
      def load(...)
        new.tap(&:persist!)
      end

      def find(graph, id)
        properties = graph
          .query("MATCH (n:#{name} {id: '#{id}'}) RETURN n")
          .resultset
          .first
          &.first
          &.reduce(&:merge)
          &.merge(graph: graph)

        return unless properties

        load(properties)
      end
    end
  end
end
