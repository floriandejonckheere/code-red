# frozen_string_literal: true

def create(type, id, title, description, **attrs)
  graph = Graph.new(name: "redis-hackathon")

  Task
    .new(graph: graph, id: id, type: type.to_s, title: title, description: description, **attrs)
    .tap(&:save)
end

def relate(from, type, to)
  graph = Graph.new(name: "redis-hackathon")

  Edge
    .new(graph: graph, from: from, type: type.to_s, to: to)
    .tap(&:save)
end

puts "== Creating tasks =="

# Project
project = create(:idea, "cb43b6e-1d79-46be-bacb-e7eeb92f79e6", "Graph project management", "Use graphs to visualize and represent tasks, features and resources.")

deploy = create(:task, "b6e0046f-ac9b-48d6-ada5-f708f5d43b24", "Deploy app", "Deploy application using a Continuous Deployment mechanism.")

relate(deploy, :child_of, project)

# Tasks
manage_tasks = create(:epic, "5b270222-14d8-4a71-9dd3-e5773a3cef1d", "Task management", "Task management involves creating, modifying and deleting tasks")
create_task = create(:feature, "f9b175ad-6283-46e0-b87b-420f737226b5", "Create a task", "As a user, I want to create a task within a project. A task can have a title, description, deadline (date), status (todo, in progress, review, done), type (task, idea, bug, feature, goal, epic) and assignee (user).")
data_model = create(:task, "bbd17f22-b4ed-470c-bf26-e66d10ef7696", "Implement data model", "Implement the data model for tasks. Tasks should be stored in Redis, and make use of the Redis Graph module.")
view_task = create(:feature, "5682c019-49b5-4e6a-9d3b-a94cc3d4f291", "View a task", "As a user, I want to view a task. A popup should display the title, description, deadline, status, type and assignee of the task.")
modify_task = create(:feature, "ee6e2bc2-e0eb-4677-b3cd-0512bac04038", "Modify a task", "As a user, I want to modify a task. I should be able to modify the title, description, deadline, status, type and assignee.")
delete_task = create(:feature, "dc58bf73-aa13-4de6-ae8d-5673e29dc38f", "Delete a task", "As a user, I want to delete a task. A confirmation modal should be displayed before the task is deleted.")

quotes = create(:bug, "62c1ef0f-aa52-4b97-a19c-65b95c93e76e", "Quotes not saved", "Tasks containing single quotes in title or description are not saved to the database. The server returns a 500 error.")

relate(manage_tasks, :child_of, project)

relate(create_task, :child_of, manage_tasks)
relate(view_task, :child_of, manage_tasks)
relate(modify_task, :child_of, manage_tasks)
relate(delete_task, :child_of, manage_tasks)

relate(data_model, :child_of, create_task)
relate(quotes, :related_to, modify_task)

# Relationships
manage_relationships = create(:epic, "55e648a3-3eaa-4b05-93ea-bf1367b8465d", "Relationship management", "Relationship management involves creating, modifying and deleting relationships between tasks")
create_relationship = create(:feature, "e931bbd1-fb19-405b-8ca5-1a59b88e9c0b", "Create a relationship", "As a user, I want to create a relationship between two tasks. A relationship should have a type: `blocks`/`blocked_by`, `parent_of`/`child_of` or `related` (bidirectional).")
view_relationship = create(:feature, "053639c3-8754-4be1-933b-d21a973ffa32", "View a tasks relationships", "As a user, I want to list all relationships, their type and their corresponding related tasks belonging to a task.")
delete_relationship = create(:feature, "1fd5bc80-5e9d-4acd-bb9c-b0c852fbdf3f", "Delete a relationship", "As a user, I want to delete a relationship. No confirmation modal should be displayed before the task is deleted.")

relate(manage_relationships, :child_of, project)

relate(manage_relationships, :blocked_by, manage_tasks)

relate(create_relationship, :child_of, manage_relationships)
relate(view_relationship, :child_of, manage_relationships)
relate(delete_relationship, :child_of, manage_relationships)

relate(view_relationship, :blocked_by, create_relationship)
relate(delete_relationship, :blocked_by, create_relationship)

# Views
views = create(:epic, "4e9f44cd-3e4a-4e2a-8361-0896d5eab2c9", "Views", "Views involve displaying, filtering and organizing tasks and their relationships on the screen")
view_graph = create(:feature, "a4d155f1-3982-4d6c-928a-5b707a6bdebb", "View graph", "As a user, I want to visualize the tasks in the project as a graph.")

graph = create(:task, "c5f14971-c624-4e31-b651-337c1be18472", "Analyze graph libraries", "Analyze existing graph JavaScript libraries, taking into account the use cases.")

relate(views, :child_of, project)

relate(view_graph, :child_of, views)
relate(graph, :child_of, view_graph)
