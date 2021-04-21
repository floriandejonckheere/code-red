# frozen_string_literal: true

FactoryBot.define do
  factory :task, class: "Task" do
    title { FFaker::Lorem.sentence(5) }
    description { FFaker::Lorem.sentence(20) }
    deadline { FFaker::Time.datetime }
    status { Task::STATUSES.sample }
    type { Task::TYPES.sample }
  end
end
