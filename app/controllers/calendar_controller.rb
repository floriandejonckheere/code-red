# frozen_string_literal: true

class CalendarController < ApplicationController
  def show
    @date = Date.new(params[:year].to_i, params[:month].to_i)

    @next = @date + 1.month
    @previous = @date - 1.month
  end
end
