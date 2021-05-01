# frozen_string_literal: true

class Node
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations
  include ActiveModel::Callbacks

  include Associations
  include Persistence::Node
  include Timestamps

  attribute :graph
  attribute :id, :string

  validates :graph,
            presence: true

  def inspect
    "#<#{self.class.name} #{attributes.compact.map { |k, v| [k, v].join('=') }.join(' ')}>"
  end
end
