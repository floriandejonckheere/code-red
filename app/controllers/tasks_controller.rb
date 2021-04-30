# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = graph.tasks
  end

  def show; end

  def new
    @task = Task.new(graph: graph)
  end

  def edit; end

  def create
    @task = Task.new(graph: graph)

    update
  end

  def update
    @task.update(task_params)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("task_form", partial: "tasks/form", locals: { task: @task })
      end
    end
  end

  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Task deleted" }
    end
  end

  private

  def graph
    @graph ||= Graph.new(name: "default")
  end

  def set_task
    @task = Task.find(graph, params[:id])
  end

  def task_params
    params
      .require(:task)
      .permit(
        :title,
        :description,
        :status,
        :type,
      )
  end
end
