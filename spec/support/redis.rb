# frozen_string_literal: true

RSpec.configure do |spec|
  spec.include RedisHelper, redis: true
end
