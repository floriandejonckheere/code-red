# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    # Change database number
    ENV["REDIS_URL"] = "redis://redis:6379/15"

    # Clear database
    Redis.new(url: ENV["REDIS_URL"]).flushdb
  end
end
