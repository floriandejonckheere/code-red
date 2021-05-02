# frozen_string_literal: true

namespace :database do
  desc "Clear database (Redis only)"
  task clear: :environment do
    Redis.new(url: ENV.fetch("REDIS_URL", "redis://redis:6379/1")).flushdb
  end
end
