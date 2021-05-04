# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :set_relationship

  def create
    @relationship = Edge.new(graph: graph)
    @relationship.update(relationship_params)

    @users = User.all.order(:name)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("task_form", partial: "tasks/form", locals: { task: @task })
      end
    end
  end

  def destroy
    @relationship.destroy

    @users = User.all.order(:name)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("task_form", partial: "tasks/form", locals: { task: @task })
      end
    end
  end

  private

  def set_relationship
    # Use task_id to render the correct task form
    @task = Task.find(graph, params[:task_id]) if params[:task_id]

    return unless params[:from_id] && params[:type] && params[:to_id]

    from = Task.find(graph, params[:from_id])
    to = Task.find(graph, params[:to_id])

    @relationship = Edge.find(graph, **Task.invert(from: from, type: params[:type], to: to))
  end

  def relationship_params
    params
      .require(:task)
      .permit(
        :from_id,
        :to_id,
        :type,
      )
  end
end