# frozen_string_literal: true

puts "== Creating projects =="

return if Project.all.any?

Project
  .create_with(
    name: "Redis Hackathon",
    description: "Experience the speed, simplicity and fun of Redis!",
    user: User.all.sample,
  )
  .find_or_create_by!(id: "055616f0-a130-42b1-a3fd-81b7c8a3ef1b")
