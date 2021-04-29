# frozen_string_literal: true

puts "== Creating users =="

return if User.all.any?

5.times.each { FactoryBot.create(:user) }
