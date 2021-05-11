# frozen_string_literal: true

class ProjectsController < ApplicationController
  def project
    @project ||= Project.find(params[:project_id])
  end
end
