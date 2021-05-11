# frozen_string_literal: true

class User < ApplicationRecord
  has_many :projects,
           dependent: :nullify

  validates :email,
            presence: true

  validates :name,
            presence: true

  def avatar
    FFaker::Avatar.image(nil, "128x128")
  end
end

# == Schema Information
#
# Table name: users
#
#  id         :uuid             not null, primary key
#  email      :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email)
#
