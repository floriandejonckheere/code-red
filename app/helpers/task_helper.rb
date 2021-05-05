# frozen_string_literal: true

module TaskHelper
  TYPES = {
    task: { icon: "briefcase", color: "gray-600" },
    epic: { icon: "lightning-bolt", color: "yellow-500" },
    idea: { icon: "light-bulb", color: "purple-600" },
    bug: { icon: "fire", color: "red-600" },
    feature: { icon: "beaker", color: "blue-600" },
    goal: { icon: "academic-cap", color: "green-500" },
  }.freeze

  def icon_for_type(type)
    TYPES.dig(type.to_sym, :icon)
  end

  def color_for_type(type)
    TYPES.dig(type.to_sym, :color)
  end
end
