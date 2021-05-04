# frozen_string_literal: true

class Task < Node
  STATUSES = %w(todo in_progress review done).freeze
  TYPES = %w(task epic idea bug feature goal).freeze

  attribute :title, :string
  attribute :description, :string
  attribute :deadline, :date
  attribute :status, :string, default: "todo"
  attribute :type, :string, default: "task"

  association :user, optional: true

  relationship :blocked_by
  relationship :blocks,
               inverse_of: :blocked_by

  relationship :child_of
  relationship :parent_of,
               inverse_of: :child_of

  relationship :related_to

  validates :title,
            presence: true

  validates :status,
            presence: true,
            inclusion: { in: STATUSES }

  validates :type,
            presence: true,
            inclusion: { in: TYPES }
end
