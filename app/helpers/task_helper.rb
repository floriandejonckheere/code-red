# frozen_string_literal: true

module TaskHelper
  TYPES = {
    idea: { icon: "light-bulb", color: "purple-400" },
    goal: { icon: "academic-cap", color: "green-500" },
    epic: { icon: "lightning-bolt", color: "yellow-500" },
    feature: { icon: "beaker", color: "blue-600" },
    task: { icon: "briefcase", color: "gray-600" },
    bug: { icon: "fire", color: "red-600" },
  }.freeze

  STATUSES = {
    todo: { color: "gray-800" },
    in_progress: { color: "indigo-500" },
    review: { color: "pink-500" },
    done: { color: "green-600" },
  }.freeze

  def icon_for_type(type)
    TYPES.dig(type.to_sym, :icon)
  end

  def color_for_type(type)
    TYPES.dig(type.to_sym, :color)
  end

  def color_for_status(status)
    STATUSES.dig(status.to_sym, :color)
  end
end
