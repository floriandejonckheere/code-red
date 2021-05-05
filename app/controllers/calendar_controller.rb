# frozen_string_literal: true

class CalendarController < ApplicationController
  before_action :set_task

  def show
    @selected = @task.deadline
    @date = Date.new(params[:year].to_i, params[:month].to_i)

    @next = @date + 1.month
    @previous = @date - 1.month
  end

  private

  def set_task
    @task = Task.find(graph, params[:task_id])
  end
end
