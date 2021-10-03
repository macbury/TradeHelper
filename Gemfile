source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.0'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'
gem 'countries'
gem 'down'
gem 'data_migrate'
gem 'dry-struct'
gem 'pry'
gem 'pry-inline'
gem 'pry-rails'
gem 'dotenv-rails'
gem 'sidekiq'
gem 'selenium-webdriver', '~> 4.0.0.alpha7'
gem 'pdf-reader', '~> 2.4', '>= 2.4.1'
gem 'nokogiri'
gem 'sidekiq-cron'
#gem 'pghero'

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'puffing-billy'
  gem 'factory_bot_rails'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :test do
  gem 'webmock', '~> 3.11'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'rubocop', require: false
  gem 'rubocop-performance', '~> 1.6', '>= 1.6.1'
  gem 'rubocop-rails', '~> 2.6'
  gem 'rubocop-rspec', require: false
  gem 'execution_time'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
