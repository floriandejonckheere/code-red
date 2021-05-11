# frozen_string_literal: true

class RelationshipsController < ProjectsController
  def create
    @relationship = Edge.new(graph: project.graph)

    from = Task.find(project.graph, relationship_params[:from_id])
    to = Task.find(project.graph, relationship_params[:to_id])

    relationship.update(**Task.invert(from: from, type: relationship_params[:type], to: to))

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("task_form", partial: "tasks/form", locals: { project: project, task: task })
      end
    end
  end

  def destroy
    relationship.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("task_form", partial: "tasks/form", locals: { project: project, task: task })
      end
    end
  end

  private

  def task
    @task ||= Task.find(project.graph, relationship_params[:task_id]) if relationship_params[:task_id]
  end

  def relationship
    @relationship ||= find_relationship
  end

  def find_relationship
    return unless relationship_params[:from_id] && relationship_params[:type] && relationship_params[:to_id]

    from = Task.find(project.graph, relationship_params[:from_id])
    to = Task.find(project.graph, relationship_params[:to_id])

    Edge.find(project.graph, **Task.invert(from: from, type: relationship_params[:type], to: to))
  end

  def relationship_params
    params
      .require(:relationship)
      .permit(
        :task_id,
        :from_id,
        :to_id,
        :type,
      )
  end
end
