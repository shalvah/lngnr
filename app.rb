require 'sinatra'
require "sinatra/reloader" if development?
require 'patron'
require 'json'


get '/' do
  "Welcome to Longener👋"
end

UPSTREAM_TIMEOUT = 10
MAX_REDIRECTS = 10

get /\/((https?):\/\/?)?(.+)/ do |_, protocol, short_url|
  pass if request.path_info == "/__sinatra__/500.png"

  short_url = "#{protocol || 'http'}://#{short_url}"
  begin
    session = Patron::Session.new({ timeout: UPSTREAM_TIMEOUT, max_redirects: MAX_REDIRECTS })
    response = session.head(short_url)
  rescue Patron::TimeoutError
    return [504, "Request to #{short_url} timed out after #{UPSTREAM_TIMEOUT} seconds. 😢"]
  rescue Patron::TooManyRedirects
    return [400, "Encountered more than #{MAX_REDIRECTS} redirects!"]
  end

  redirect(response.url)
end

set :show_exceptions, false

error do
  content_type :json
  status 500

  e = env['sinatra.error']
  response = {error: e.message, trace: e.backtrace}
  response.delete(:trace) if settings.production?
  response.to_json
end