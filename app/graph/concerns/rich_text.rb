# frozen_string_literal: true

##
# Mimick ActionText's API without the dependency on ActiveRecord::Associations
#
module RichText
  extend ActiveSupport::Concern

  included do
    class_attribute :rich_texts

    self.rich_texts = []

    after_save :save_rich_text
    after_destroy :destroy_rich_text

    def save_rich_text
      rich_texts.each(&:save!)
    end

    def destroy_rich_text
      rich_texts.each(&:destroy!)
    end
  end

  class_methods do
    def rich_text(name)
      rich_texts << name

      define_method(name) do
        send(:"rich_text_#{name}") || send(:"build_rich_text_#{name}")
      end

      define_method(:"#{name}?") do
        send(:"rich_text_#{name}").present?
      end

      define_method(:"#{name}=") do |body|
        send(name).body = body
      end

      define_method(:"rich_text_#{name}") do
        ActionText::RichText.find_by(record_id: id, name: name)
      end

      define_method(:"build_rich_text_#{name}") do
        ActionText::RichText.new(record_id: id, name: name)
      end
    end
  end
end
