# frozen_string_literal: true

FactoryBot.define do
  factory :project, class: "Project" do
    name { FFaker::Name.name }
    description { FFaker::Lorem.sentence }

    user
  end
end
