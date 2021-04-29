# frozen_string_literal: true

module Persistence
  extend ActiveSupport::Concern

  included do
    def destroy
      return false unless !destroyed? && (persisted? || !id.nil?)

      graph
        .query("MATCH (n:#{self.class.name} {id: '#{id}'}) DELETE n")

      @_destroyed = true
      @_persisted = false

      freeze

      true
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
end
