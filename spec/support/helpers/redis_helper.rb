# frozen_string_literal: true

module RedisHelper
  def self.included(config)
    config.before do
      # Change database number
      ENV["REDIS_URL"] = "redis://redis:6379/15"

      # Clear database
      Redis.connect(ENV["REDIS_URL"]).flushdb
    end
  end
end
