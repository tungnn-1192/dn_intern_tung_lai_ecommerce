source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.0"

gem "bcrypt"
gem "bootsnap", ">= 1.4.4", require: false
gem "config"
gem "jbuilder", "~> 2.7"
gem "kaminari"
gem "puma", "~> 5.0"
gem "rails", "~> 6.1.4", ">= 6.1.4.1"
gem "rails-i18n"
gem "sass-rails", ">= 6"
gem "strings-case"
gem "turbolinks", "~> 5"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "webpacker", "~> 5.0"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]

  # rspec
  gem "rspec-rails", "~> 4.0.1"

  # rubocop
  gem "rubocop", "~> 0.74.0", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.3.2", require: false

  # db: mysql2
  gem "faker"
  gem "mysql2"
end

group :development do
  gem "listen", "~> 3.3"
  gem "pry-nav"
  gem "pry-rails"
  gem "rack-mini-profiler", "~> 2.0"
  gem "spring"
  gem "web-console", ">= 4.1.0"
end

group :test do
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  gem "webdrivers"
end

group :production do
  gem "pg"
end
