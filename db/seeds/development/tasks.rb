# frozen_string_literal: true

def create(type, id, title, description, **attrs)
  graph = Graph.new(name: "default")

  Task
    .new(graph: graph, id: id, type: type.to_s, title: title, description: description, **attrs)
    .tap(&:save)
end

def relate(from, type, to)
  graph = Graph.new(name: "default")

  Edge
    .new(graph: graph, from: from, type: type.to_s, to: to)
    .tap(&:save)
end

puts "== Creating tasks =="

# Tasks
manage_tasks = create(:epic, "5b270222-14d8-4a71-9dd3-e5773a3cef1d", "Task management", "Task management involves creating, modifying and deleting tasks")
create_task = create(:task, "f9b175ad-6283-46e0-b87b-420f737226b5", "Create a task", "As a user, I want to create a task within a project. A task can have a title, description, deadline (date), status (todo, in progress, review, done), type (task, idea, bug, feature, goal, epic) and assignee (user).")
view_task = create(:task, "5682c019-49b5-4e6a-9d3b-a94cc3d4f291", "View a task", "As a user, I want to view a task. A popup should display the title, description, deadline, status, type and assignee of the task.")
modify_task = create(:task, "ee6e2bc2-e0eb-4677-b3cd-0512bac04038", "Modify a task", "As a user, I want to modify a task. I should be able to modify the title, description, deadline, status, type and assignee.")
delete_task = create(:task, "dc58bf73-aa13-4de6-ae8d-5673e29dc38f", "Delete a task", "As a user, I want to delete a task. A confirmation modal should be displayed before the task is deleted.")

relate(create_task, :child_of, manage_tasks)
relate(view_task, :child_of, manage_tasks)
relate(modify_task, :child_of, manage_tasks)
relate(delete_task, :child_of, manage_tasks)

relate(view_task, :blocked_by, create_task)
relate(modify_task, :blocked_by, create_task)
relate(delete_task, :blocked_by, create_task)

# Relationships
manage_relationships = create(:epic, "55e648a3-3eaa-4b05-93ea-bf1367b8465d", "Relationship management", "Relationship management involves creating, modifying and deleting relationships between tasks")
create_relationship = create(:task, "e931bbd1-fb19-405b-8ca5-1a59b88e9c0b", "Create a relationship", "As a user, I want to create a relationship between two tasks. A relationship should have a type: `blocks`/`blocked_by`, `parent_of`/`child_of` or `related` (bidirectional).")
view_relationship = create(:task, "053639c3-8754-4be1-933b-d21a973ffa32", "View a tasks relationships", "As a user, I want to list all relationships, their type and their corresponding related tasks belonging to a task.")
delete_relationship = create(:task, "1fd5bc80-5e9d-4acd-bb9c-b0c852fbdf3f", "Delete a relationship", "As a user, I want to delete a relationship. No confirmation modal should be displayed before the task is deleted.")

relate(manage_relationships, :blocked_by, manage_tasks)

relate(create_relationship, :child_of, manage_relationships)
relate(view_relationship, :child_of, manage_relationships)
relate(delete_relationship, :child_of, manage_relationships)

relate(view_relationship, :blocked_by, create_relationship)
relate(delete_relationship, :blocked_by, create_relationship)

# Views
views = create(:epic, "4e9f44cd-3e4a-4e2a-8361-0896d5eab2c9", "Views", "Views involve displaying, filtering and organizing tasks and their relationships on the screen")
view_graph = create(:task, "a4d155f1-3982-4d6c-928a-5b707a6bdebb", "View graph", "As a user, I want to visualize the tasks in the project as a graph.")

relate(view_graph, :child_of, views)
