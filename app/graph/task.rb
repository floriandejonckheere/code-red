# frozen_string_literal: true

# 62c1ef0f-aa52-4b97-a19c-65b95c93e76e
# 6d19a810-4715-47a6-8fdc-e22e28f2526d
# 2c74ee65-9969-46d0-be5b-ec4b1cdacacd
# 39188d78-c3b4-41a6-acc9-7997ca445878
# f01c9444-26a8-4002-a7c8-9c3656d19f29
# ad1f354b-f6cf-4e39-9937-189dd1af8bd6
# 8b2b47ee-abbe-4919-8ff5-a495944104b2
# bde80cb0-af8e-4106-802b-c5dd0b006ae4

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
