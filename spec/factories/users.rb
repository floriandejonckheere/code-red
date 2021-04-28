# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: "User" do
    name { FFaker::Name.name }
    email { FFaker::Internet.email(name) }
  end
end
