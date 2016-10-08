require 'rack'
require_relative '../freegeoip'
require_relative '../../models/country'

class Rack::Geolocation
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      ip_address = env["REMOTE_ADDR"] unless is_local_network?(env["REMOTE_ADDR"])
      geo_data   = FreeGeoIP.geolocate(ip_address)

      env["rack.geo_data"] = geo_data

      if geo_data[:country_code]
        country = Country[geo_data[:country_code]]

        env["rack.language"] = country.languages.split(",").first
      end
    rescue => e
      puts "#" * 10
      puts "Error geolocating IP: #{e}"
      puts "#" * 10

      env["rack.geo_data"] = {}
    end

    @app.call(env)
  end

  private

  def is_local_network?(ip_address)
    /(192|127|10)\.\d{1,3}\.\d{1,3}\.\d{1,3}/ =~ ip_address
  end
end
