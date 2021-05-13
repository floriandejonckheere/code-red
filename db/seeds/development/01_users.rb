# frozen_string_literal: true

puts "== Creating users =="

return if User.any?

User.create!(name: "Darth Vader", email: "darthvader@example.com")
User.create!(name: "Luke Skywalker", email: "lukeskywalker@example.com")
User.create!(name: "Obi-Wan Kenobi", email: "obiwankenobi@example.com")
User.create!(name: "Han Solo", email: "hansolo@example.com")
User.create!(name: "Chewbacca", email: "chewbacca@example.com")
