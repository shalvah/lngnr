require 'sinatra/base'


class MockServer < Sinatra::Base
  LONG_URL = "http://localhost:9494/longlonglonglong"

  set :port, 9494
  set :server, "webrick"
  disable :logging
  set :server_settings, {AccessLog: []} # DIsable WEBRick access logs

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