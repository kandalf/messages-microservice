require "cuba"
require "cuba/safe"
require "sequel"
require_relative "helpers/environment_helper"

ENV["RACK_ENV"] ||= "development"
DB = MessageService::Helpers.init_environment(ENV["RACK_ENV"])

puts DB

Cuba.plugin Cuba::Safe

Cuba.use Rack::MethodOverride

Dir["./lib/**/*.rb"].each        { |rb| require rb }
Dir["./models/**/*.rb"].each     { |rb| require rb }
Dir["./validators/**/*.rb"].each { |rb| require rb }
Dir["./concerns/**/*.rb"].each   { |rb| require rb }
Dir["./routes/**/*.rb"].each     { |rb| require rb }
Dir["./helpers/**/*.rb"].each    { |rb| require rb }

Cuba.plugin MessageService::Helpers

Cuba.define do
  run Routes::MessageService
end
