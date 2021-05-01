# frozen_string_literal: true

class Edge
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations
  include ActiveModel::Callbacks

  include Associations

  TYPES = %w(related_to blocks blocked_by parent_of child_of).freeze

  attribute :graph
  attribute :type, :string, default: "related_to"

  association :from, "Task"
  association :to, "Task"

  validates :graph,
            presence: true

  validates :type,
            presence: true,
            inclusion: { in: TYPES }
end
