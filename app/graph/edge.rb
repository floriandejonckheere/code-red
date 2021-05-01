# frozen_string_literal: true

class Edge
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations
  include ActiveModel::Callbacks

  include Associations
  include Persistence::Edge

  TYPES = %w(related_to blocked_by child_of).freeze

  attribute :graph
  attribute :type, :string, default: "related_to"

  # TODO: use associations/attributes
  attr_accessor :from, :to

  validates :graph,
            presence: true

  validates :type,
            presence: true,
            inclusion: { in: TYPES }
end
