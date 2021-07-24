# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 6.1.3", ">= 6.1.3.1"
# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"
# Use Puma as the app server
gem "puma", "~> 5.0"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"
# Use Active Model has_secure_password
gem "bcrypt", "~> 3.1.7"
# Use webpacker to manage assets
gem "webpacker"

# Redis Graph library
gem "redisgraph", "~> 2.0"

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Send HTML over the wire instead of JSON
gem "hotwire-rails", "~> 0.1.3"

# Send HTML over the wire instead of JSON
gem "turbo-rails"

# Hand-crafted SVG icons, by Tailwind
gem "heroicon", "~> 0.3.0"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

# Timezone data
gem "tzinfo-data"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug"
  # gem "debase"
  # gem "ruby-debug-ide"

  # Database annotations
  # FIXME: revert to upstream gem when https://github.com/ctran/annotate_models/pull/843 is merged
  gem "annotate", github: "Vasfed/annotate_models", branch: "rails6_warning"

  # RuboCop
  gem "rubocop"
  gem "rubocop-performance"
  gem "rubocop-rails"
  gem "rubocop-rspec"

  # RSpec
  gem "rspec"
  gem "rspec-rails"

  # Shoulda-matchers
  gem "shoulda-matchers"

  # Time behaviour
  gem "timecop"

  # Factory testing pattern
  gem "factory_bot"
  gem "factory_bot_rails"
  gem "ffaker"

  # Mock HTTP requests
  gem "webmock"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 4.1.0"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "listen", "~> 3.3"
  # gem "rack-mini-profiler", "~> 2.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"

  # Static code analysis tools
  gem "brakeman"
  gem "fasterer"
  gem "flay"
  gem "overcommit"
  gem "pronto"
  gem "rails_best_practices"
  gem "reek"
end
