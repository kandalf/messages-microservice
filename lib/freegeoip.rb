require 'net/http'
require 'json'

module FreeGeoIP
  SERVICE_URL = "https://freegeoip.net/json"

  def self.geolocate(ip_address = nil)
    uri      = URI.parse("#{SERVICE_URL}/#{ip_address}")
    response = Net::HTTP.get_response(uri)

    response.is_a?(Net::HTTPSuccess) ? JSON.parse(response.body) : {}
  end
end
