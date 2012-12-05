source 'http://rubygems.org'

gem 'rails', '3.1.3'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# For prod environment as of now
group :production do
  gem 'mysql2'
end

group :development, :test do
  gem 'pg'
end

gem "haml-rails"
gem 'json'
gem 'inherited_resources'
gem 'activeadmin'
gem "kaminari"
gem "has_scope"
gem "capistrano"

# Moving sass-rails out of assets group because of rake db:migrate failure in travis CI
gem 'sass-rails',   '~> 3.1.5'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'
group :test, :development, :ci do
  gem "rspec-rails", "~> 2.6"
  gem 'shoulda-matchers'
end

