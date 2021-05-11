# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :user,
             optional: true

  validates :name,
            presence: true

  def graph
    @graph ||= Graph.new(name: id)
  end

  delegate :tasks, to: :graph
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
