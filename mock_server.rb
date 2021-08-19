require 'sinatra/base'
require 'webrick'

class MockServer < Sinatra::Base
  LONG_URL = "http://localhost:9494/longlonglonglong"

  set :port, 9494
  set :server, "webrick"
  disable :logging
  # DIsable WEBRick stdout noise
  set :server_settings, {AccessLog: [], Logger: WEBrick::Log.new(File::NULL)}

  get '/testing' do
    redirect LONG_URL
  end

  get '/longlonglonglong' do
    "Heyy"
  end

  get '/redirector' do
    redirect '/redirector'
  end

end

MockServer.run!