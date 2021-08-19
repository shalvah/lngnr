# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem "sinatra", "~> 2.1"

# Needed for sinatra/reloader
gem "sinatra-contrib", "~> 2.1"

gem "patron", "~> 0.13.3"

group :test do
  gem "rack-test", "~> 1.1"
  gem "minitest", "~> 5.14"
  gem "minitest-reporters", "~> 1.4"
end

gem "win32console", "~> 1.3", :group => :windows

gem "rake", "~> 13.0"
