# frozen_string_literal: true

class CalendarController < ProjectsController
  def show
    date = Date.new(params[:year].to_i, params[:month].to_i)

    past = date - 1.month
    future = date + 1.month

    render locals: { project: project, task: task, date: date, past: past, future: future }
  end

  private

  def task
    @task ||= Task.find(project.graph, params[:task_id]) if params[:task_id]
  end
end
