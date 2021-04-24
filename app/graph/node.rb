# frozen_string_literal: true

class Node
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :graph
  attribute :id, :string

  validates :graph,
            presence: true

  def save
    validate!

    self.id ||= SecureRandom.uuid

    properties = attributes
      .except(:graph)
      .map { |k, v| "n.#{k} = '#{v}'" }
      .join(", ")

    graph
      .query("MERGE (n:#{self.class.name} {id: '#{id}'}) SET #{properties}")
  end

  def ==(other)
    other.instance_of?(self.class) &&
      !id.nil? &&
      other.id = id
  end

  def inspect
    "#<#{self.class.name} #{attributes.compact.map { |k, v| [k, v].join('=') }.join(' ')}>"
  end
end
