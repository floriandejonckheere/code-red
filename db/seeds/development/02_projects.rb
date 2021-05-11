# frozen_string_literal: true

puts "== Creating projects =="

return if Project.all.any?

Project.create!(
  name: "Redis Hackathon",
  description: "Experience the speed, simplicity and fun of Redis!",
  user: User.all.sample,
)
