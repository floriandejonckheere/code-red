# frozen_string_literal: true

namespace :database do
  desc "Seed production and development database"
  task seed: %w(seed:production seed:development)

  namespace :seed do
    desc "Seed production database"
    task production: :environment do
      # Turn off SQL log
      ActiveRecord::Base.logger = nil

      Dir[Rails.root.join("db/seeds/*.rb")].each { |f| require f }
    end

    desc "Seed development database"
    task development: :environment do
      # Turn off SQL log
      ActiveRecord::Base.logger = nil

      Dir[Rails.root.join("db/seeds/development/*.rb")].each { |f| require f }
    end
  end
end
