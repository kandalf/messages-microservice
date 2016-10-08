require 'minitest/spec'
require 'minitest/autorun'
require 'pp'
require 'rack/test'
require 'mocha/mini_test'

ENV["RACK_ENV"]  = 'test'

require File.dirname(__FILE__) + '/../app'

class MiniTest::Spec
  include Rack::Test::Methods
  include Mocha::Integration::MiniTest::Adapter

  def app
    Cuba.app
  end
end

def json_post(path, params = {}, headers = {})
  json_headers = headers.merge("CONTENT_TYPE" => "application/json")

  body = JSON.dump(params)

  post path, body, json_headers
end

def json_get(path, headers = {})
  json_headers = headers.merge("CONTENT_TYPE" => "application/json")

  get path, {}, json_headers
end
