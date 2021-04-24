# frozen_string_literal: true

class Node
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  def inspect
    "#<#{self.class.name} #{attributes.compact.map { |k, v| [k, v].join('=') }.join(' ')}>"
  end
end
