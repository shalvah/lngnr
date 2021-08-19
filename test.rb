require './app'
require 'minitest'
require 'rack/test'
require "minitest/reporters"

pid = spawn("ruby", "./mock_server.rb")
sleep 1

SHORT_URL_DOMAIN = "localhost:9494"
LONG_URL = "http://localhost:9494/longlonglonglong"

class LngnrTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_home
    get '/'
    assert_equal "Welcome to Lngnr👋", last_response.body
  end

  def test_can_resolve_url_wihout_protocol
    get "/#{SHORT_URL_DOMAIN}/testing"
    assert_equal 302, last_response.status
    assert_equal LONG_URL, last_response.header['Location']
  end

  def test_can_resolve_url_with_protocol
    get "/http://#{SHORT_URL_DOMAIN}/testing"
    assert_equal 302, last_response.status
    assert_equal LONG_URL, last_response.header['Location']
  end

  def test_fails_if_too_many_redirects
    get "/http://#{SHORT_URL_DOMAIN}/redirector"
    assert_equal 400, last_response.status
  end
end

LngnrTest.run(Minitest::Reporters::SpecReporter.new)
Process.kill("SIGKILL", pid)