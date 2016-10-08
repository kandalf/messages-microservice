require "cuba"
require "cuba/safe"
require "sequel"
require "json"
require "rack/parser"
require_relative "helpers/environment_helper"

ENV["RACK_ENV"] ||= "development"
MessageService::Helpers.init_environment(ENV["RACK_ENV"])

Cuba.plugin Cuba::Safe

Cuba.use Rack::MethodOverride

Dir["./lib/**/*.rb"].each        { |rb| require rb }
Dir["./models/**/*.rb"].each     { |rb| require rb }
Dir["./validators/**/*.rb"].each { |rb| require rb }
Dir["./presenters/**/*.rb"].each { |rb| require rb }
Dir["./routes/**/*.rb"].each     { |rb| require rb }
Dir["./helpers/**/*.rb"].each    { |rb| require rb }

Cuba.plugin MessageService::Helpers
Cuba.use Rack::Geolocation

Cuba.define do
  run Routes::MessageService
end
