# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project

  delegate :graph, to: :@project

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
