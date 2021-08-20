require './app'
require 'rspec'
require 'rack/test'

RSpec.configure do |c|
  pid = nil
  c.before(:context) do
    pid = spawn("ruby", "./spec/mock_server.rb")
    sleep 1
  end
  c.after(:context) do
    Process.kill("SIGKILL", pid)
  end
end

RSpec.describe 'Lngnr' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  SHORT_URL_DOMAIN = "localhost:9494"
  LONG_URL = "http://localhost:9494/longlonglonglong"

  it "renders home page" do
    get '/'
    expect(last_response).to be_ok
  end

  it "can resolve url wihout protocol" do
    get "/#{SHORT_URL_DOMAIN}/testing"
    expect(last_response.status).to eq 301
    expect(last_response.header['Location']).to eq LONG_URL
  end

  it "can resolve url with protocol" do
    get "/http://#{SHORT_URL_DOMAIN}/testing"
    expect(last_response.status).to eq 301
    expect(last_response.header['Location']).to eq LONG_URL
  end

  it "fails if too many redirects" do
    get "/http://#{SHORT_URL_DOMAIN}/redirector"
    expect(last_response.status).to eq 400
  end
end