# frozen_string_literal: true

module Associations
  extend ActiveSupport::Concern

  included do
    class_attribute :associations

    self.associations = {}
  end

  class_methods do
    def association(name, type = name, optional: false)
      associations[name] = type

      attribute :"#{name}_id", :string

      unless optional
        validates :"#{name}_id",
                  presence: true
      end

      define_method(name) do
        id = send(:"#{name}_id")

        type.to_s.camelize.constantize.find(id) if id.present?
      end

      define_method(:"#{name}=") do |model|
        send(:"#{name}_id=", model&.id)
      end
    end
  end
end
