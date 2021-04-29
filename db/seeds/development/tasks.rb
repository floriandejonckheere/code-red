# frozen_string_literal: true

def create(type, id, title, description, **attrs)
  graph = Graph.new(name: "default")

  Task
    .new(graph: graph, id: id, type: type.to_s, title: title, description: description, **attrs)
    .save
end

puts "== Creating tasks =="

create(:epic, "5b270222-14d8-4a71-9dd3-e5773a3cef1d", "Task management", "Task management involves creating, modifying and deleting tasks")
create(:task, "f9b175ad-6283-46e0-b87b-420f737226b5", "Create a task", "As a user, I want to create a task within a project")
create(:task, "5682c019-49b5-4e6a-9d3b-a94cc3d4f291", "View a task", "As a user, I want to view a task")
create(:task, "ee6e2bc2-e0eb-4677-b3cd-0512bac04038", "Modify a task", "As a user, I want to modify a task")
create(:task, "dc58bf73-aa13-4de6-ae8d-5673e29dc38f", "Delete a task", "As a user, I want to delete a task")
