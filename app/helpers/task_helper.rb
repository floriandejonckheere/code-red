# frozen_string_literal: true

module TaskHelper
  TYPES = {
    task: { icon: "briefcase", color: "gray" },
    epic: { icon: "lightning-bolt", color: "yellow" },
    idea: { icon: "light-bulb", color: "purple" },
    bug: { icon: "fire", color: "red" },
    feature: { icon: "beaker", color: "blue" },
    goal: { icon: "academic-cap", color: "green" },
  }.freeze

  def icon_for(type)
    TYPES.dig(type.to_sym, :icon)
  end

  def color_for(type)
    TYPES.dig(type.to_sym, :color)
  end
end
