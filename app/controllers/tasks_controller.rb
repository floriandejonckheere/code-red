# frozen_string_literal: true

class TasksController < ProjectsController
  def index
    render locals: { project: project, users: users }
  end

  def new
    @task = Task.new(graph: project.graph)

    render locals: { project: project, task: task }
  end

  def edit
    render locals: { project: project, task: task }
  end

  def create
    @task = Task.new(graph: project.graph)

    update
  end

  def update
    task.update(task_params)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("task_form", partial: "tasks/form", locals: { project: project, task: task, notice: "Task saved" })
      end
    end
  end

  def destroy
    task.destroy

    respond_to do |format|
      format.html { redirect_to project_tasks_path(project_id: project.id), notice: "Task deleted" }
    end
  end

  private

  def task
    @task ||= Task.find(project.graph, params[:id])
  end

  def users
    @users ||= User.all.order(:name)
  end

  def task_params
    params
      .require(:task)
      .permit(
        :title,
        :description,
        :status,
        :type,
        :user_id,
        :deadline,
      )
  end
end
