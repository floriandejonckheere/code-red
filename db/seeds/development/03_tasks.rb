# frozen_string_literal: true

puts "== Creating tasks =="

def create(graph, type, title, description, **attrs)
  Task
    .new(graph: graph, type: type.to_s, title: title, description: description, **attrs)
    .tap(&:save)
end

def relate(from, type, to)
  Edge
    .new(graph: from.graph, from: from, type: type.to_s, to: to)
    .tap(&:save)
end

Project.find_each do |project|
  next if project.tasks.any?

  # Project
  project = create(project.graph, :idea, "Graph project management", "Use graphs to visualize and represent tasks, features and resources.")

  deploy = create(project.graph, :task, "Deploy app", "Deploy application using a Continuous Deployment mechanism.")

  relate(deploy, :child_of, project)

  # Tasks
  manage_tasks = create(project.graph, :epic, "Task management", "Task management involves creating, modifying and deleting tasks")
  create_task = create(project.graph, :feature, "Create a task", "As a user, I want to create a task within a project. A task can have a title, description, deadline (date), status (todo, in progress, review, done), type (task, idea, bug, feature, goal, epic) and assignee (user).")
  view_task = create(project.graph, :feature, "View a task", "As a user, I want to view a task. A popup should display the title, description, deadline, status, type and assignee of the task.")
  modify_task = create(project.graph, :feature, "Modify a task", "As a user, I want to modify a task. I should be able to modify the title, description, deadline, status, type and assignee.")
  delete_task = create(project.graph, :feature, "Delete a task", "As a user, I want to delete a task. A confirmation modal should be displayed before the task is deleted.")

  analyze_data = create(project.graph, :task, "Analyze data model", "Analyze the data model for tasks. Construct an ERD.")
  implement_data = create(project.graph, :task, "Implement data model", "Implement the data model for tasks. Tasks should be stored in Redis, and make use of the Redis Graph module.")

  quotes = create(project.graph, :bug, "Quotes not saved", "Tasks containing single quotes in title or description are not saved to the database. The server returns a 500 error.")
  saved = create(project.graph, :bug, "Graph not updated on save", "After saving a task, the rendered graph does not update automatically.")

  relate(manage_tasks, :child_of, project)

  relate(create_task, :child_of, manage_tasks)
  relate(view_task, :child_of, manage_tasks)
  relate(modify_task, :child_of, manage_tasks)
  relate(delete_task, :child_of, manage_tasks)

  relate(analyze_data, :child_of, create_task)
  relate(implement_data, :child_of, create_task)
  relate(quotes, :related_to, modify_task)
  relate(saved, :related_to, modify_task)

  # Relationships
  manage_relationships = create(project.graph, :epic, "Relationship management", "Relationship management involves creating, modifying and deleting relationships between tasks")
  create_relationship = create(project.graph, :feature, "Create a relationship", "As a user, I want to create a relationship between two tasks. A relationship should have a type: `blocks`/`blocked_by`, `parent_of`/`child_of` or `related` (bidirectional).")
  view_relationship = create(project.graph, :feature, "View a tasks relationships", "As a user, I want to list all relationships, their type and their corresponding related tasks belonging to a task.")
  delete_relationship = create(project.graph, :feature, "Delete a relationship", "As a user, I want to delete a relationship. No confirmation modal should be displayed before the task is deleted.")

  relate(manage_relationships, :child_of, project)

  relate(manage_relationships, :blocked_by, manage_tasks)

  relate(create_relationship, :child_of, manage_relationships)
  relate(view_relationship, :child_of, manage_relationships)
  relate(delete_relationship, :child_of, manage_relationships)

  # Views
  views = create(project.graph, :epic, "Views", "Views involve displaying, filtering and organizing tasks and their relationships on the screen")
  view_graph = create(project.graph, :feature, "View graph", "As a user, I want to visualize the tasks in the project as a graph.")
  view_timeline = create(project.graph, :feature, "View timeline", "As a user, I want to visualize the tasks in the project in a timeline. Tasks blocked by other tasks should appear first in the timeline. Tasks with a deadline should appear on that date in the timeline.")

  analyze_graph = create(project.graph, :task, "Analyze graph libraries", "Analyze existing graph JavaScript libraries, taking into account the use cases.")
  implement_graph = create(project.graph, :task, "Implement graph library", "Implement the graph rendering algorithm using the JavaScript graph library.")
  overlap = create(project.graph, :bug, "Tasks overlap", "Disconnected tasks can overlap other tasks. Fix the bounding box algorithm to take into account disconnected graphs.")

  relate(views, :child_of, project)

  relate(view_graph, :child_of, views)
  relate(analyze_graph, :child_of, view_graph)
  relate(implement_graph, :child_of, view_graph)
  relate(overlap, :child_of, view_graph)

  relate(view_timeline, :child_of, views)
end
