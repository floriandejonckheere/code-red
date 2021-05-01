# frozen_string_literal: true

module Relationships
  extend ActiveSupport::Concern

  included do
    class_attribute :relationships

    self.relationships = {}
  end

  class_methods do
    def relationship(name, type = name.to_s, inverse_of: nil)
      relationships[name] = { type: type, inverse_of: inverse_of }

      define_method(name) do
        return [] unless persisted?

        if inverse_of
          Edge
            .where(graph, from: self.class.new, type: inverse_of, to: self)
            .map(&:from)
        else
          Edge
            .where(graph, from: self, type: type, to: self.class.new)
            .map(&:to)
        end
      end
    end
  end
end
