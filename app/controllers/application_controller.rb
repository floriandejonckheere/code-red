# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def index; end

  def graph
    @graph ||= Graph.new(name: "default")
  end
end
