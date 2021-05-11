# frozen_string_literal: true

class Project < ApplicationRecord
  after_initialize :set_graph_id

  belongs_to :user,
             optional: true

  validates :name,
            presence: true

  validates :graph_id,
            presence: true

  def graph
    @graph ||= Graph.new(name: graph_id)
  end

  delegate :tasks, to: :graph

  private

  def set_graph_id
    self.graph_id ||= name.parameterize
  end
end

# == Schema Information
#
# Table name: projects
#
#  id          :uuid             not null, primary key
#  description :string
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  graph_id    :string           not null
#  user_id     :uuid
#
# Indexes
#
#  index_projects_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id) ON DELETE => nullify
#
