# frozen_string_literal: true

def create(type, title, description, **attrs)
  graph = Graph.new(name: "default")

  Task
    .new(graph: graph, type: type.to_s, title: title, description: description, **attrs)
    .save
end

puts "== Creating tasks =="

# Ensure repeatable seeds
srand 1_234_567_890

create(:epic, "Task management", "Task management involves creating, modifying and deleting tasks")
create(:task, "Create a task", "As a user, I want to create a task within a project")
create(:task, "View a task", "As a user, I want to view a task")
create(:task, "Modify a task", "As a user, I want to modify a task")
create(:task, "Delete a task", "As a user, I want to delete a task")
