# frozen_string_literal: true

class Task < Node
  STATUSES = %w(todo in_progress review done).freeze
  TYPES = %w(task epic idea bug feature goal).freeze

  attribute :title, :string
  attribute :description, :string
  attribute :deadline, :date
  attribute :status, :string, default: "todo"
  attribute :type, :string, default: "task"

  validates :title,
            presence: true

  validates :status,
            presence: true,
            inclusion: { in: STATUSES }

  validates :type,
            presence: true,
            inclusion: { in: TYPES }

  def type_icon
    {
      task: "briefcase",
      epic: "lightning-bolt",
      idea: "light-bulb",
      bug: "fire",
      feature: "beaker",
      goal: "academic-cap",
    }[type.to_sym]
  end
end
