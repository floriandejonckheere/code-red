# frozen_string_literal: true

FactoryBot.define do
  factory :graph, class: "Graph" do
    initialize_with { Graph.new(name: name) }

    name { FFaker::Lorem.word }
  end

  factory :node, class: "Node" do
    to_create(&:save)

    graph
  end

  factory :edge, class: "Edge" do
    to_create(&:save)

    type { Edge::TYPES.sample }

    from { create(:node, graph: graph) }
    to { create(:node, graph: graph) }

    graph
  end

  factory :task, parent: :node, class: "Task" do
    title { FFaker::Lorem.sentence(5) }
    description { FFaker::Lorem.sentence(20) }
    deadline { FFaker::Time.datetime }
    status { Task::STATUSES.sample }
    type { Task::TYPES.sample }

    association :user
  end
end
