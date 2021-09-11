require 'sinatra'
require "sinatra/reloader" if development?
require 'patron'
require 'json'
require 'zlib'

UPSTREAM_CONNECT_TIMEOUT = 4
UPSTREAM_READ_TIMEOUT = 10
MAX_REDIRECTS = 10

index_hash = Zlib::crc32(File.read("views/index.erb"))
server_start = Time.now

get '/' do
  # Cache homepage for 3 days at least
  expires(3 * 24 * 60 * 60, :public)
  last_modified server_start
  etag index_hash

  erb :index
end

get /\/((https?):\/\/?)?(.+)/ do |_, protocol, short_url|
  not_found if request.path_info == "/favicon.ico"
  pass if request.path_info == "/__sinatra__/500.png"

  # t0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  short_url = "#{protocol || 'http'}://#{short_url}"
  short_url += "?#{request.query_string}" if request.query_string
  begin
    session = Patron::Session.new({
      connect_timeout: UPSTREAM_CONNECT_TIMEOUT,
      timeout: UPSTREAM_READ_TIMEOUT,
      max_redirects: MAX_REDIRECTS,
      insecure: true,
    })
    # session.enable_debug 'patron.log'
    response = session.head(short_url)
    # t1 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    # p "Got response in #{t1 - t0}s"
  rescue Patron::TimeoutError
    return [504, "Request to #{short_url} timed out. 😢"]
  rescue Patron::TooManyRedirects
    return [400, "Encountered more than #{MAX_REDIRECTS} redirects!"]
  end

  redirect(response.url, 301)
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