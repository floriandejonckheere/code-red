# frozen_string_literal: true

module Persistence
  module Edge
    extend ActiveSupport::Concern

    included do
      define_model_callbacks :destroy, :save

      # rubocop:disable Metrics/AbcSize
      def destroy
        run_callbacks :destroy do
          return false unless !destroyed? && persisted?

          graph
            .match(:n, from.class.name, id: from.id)
            .to(:r, type)
            .match(:m, to.class.name)
            .delete(:r)
            .execute

          @_destroyed = true
          @_persisted = false

          freeze

          true
        end
      end
      # rubocop:enable Metrics/AbcSize

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

      # rubocop:disable Metrics/AbcSize
      def save
        run_callbacks :save do
          return false unless valid?

          graph
            .match(:n, from.class.name, id: from.id)
            .match(:m, to.class.name, id: to.id)
            .merge(:n)
            .to(:r, type)
            .merge(:m)
            .execute

          @_persisted = true
        end
      end
      # rubocop:enable Metrics/AbcSize

      def update(attributes)
        assign_attributes(attributes)

        save
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
        graph
          .match(:n, from&.class&.name, **{ id: from&.id }.compact)
          .to(:r, type)
          .match(:m, to&.class&.name, **{ id: to&.id }.compact)
          .return(:n, :m, t: "type(r)")
          .map do |result|
          from = from.class.load(result[:n].merge(graph: graph))
          type = result[:t]
          to = to.class.load(result[:m].merge(graph: graph))

          load(graph: graph, from: from, type: type, to: to)
        end
      end
      # rubocop:enable Metrics/AbcSize

      def find(...)
        where(...).first
      end
    end
  end
end
