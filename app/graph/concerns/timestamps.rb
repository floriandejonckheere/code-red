# frozen_string_literal: true

module Timestamps
  extend ActiveSupport::Concern

  included do
    attribute :created_at, :datetime
    attribute :updated_at, :datetime

    before_save :set_timestamps

    def set_timestamps
      self.created_at ||= Time.zone.now
      self.updated_at = Time.zone.now
    end
  end
end
