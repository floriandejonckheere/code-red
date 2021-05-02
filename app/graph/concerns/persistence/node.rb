# frozen_string_literal: true

module Persistence
  module Node
    extend ActiveSupport::Concern

    included do
      define_model_callbacks :destroy, :save

      def destroy
        run_callbacks :destroy do
          return false unless !destroyed? && persisted?

          graph
            .match(:n, self.class.name, id: id)
            .delete(:n)
            .execute

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

      def reload
        return false unless persisted?

        assign_attributes graph
          .match(:n, self.class.name, id: id)
          .return(:n)
          .first
          &.fetch(:n)

        true
      end

      def save
        run_callbacks :save do
          return false unless valid?

          self.id ||= SecureRandom.uuid

          graph
            .merge(:n, self.class.name, id: id)
            .set(**attributes.except(:graph))
            .execute

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
        new(...).tap(&:persist!)
      end

      def find(graph, id)
        attributes = graph
          .match(:n, name, id: id)
          .return(:n)
          .first
          &.fetch(:n)
          &.merge(graph: graph)

        return unless attributes

        load(attributes)
      end
    end
  end
end
