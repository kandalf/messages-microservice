require_relative '../test_helper'

describe 'POST /' do
  before do
    @geo_data = {
      ip: "127.0.0.1",
      country_code: "AR",
      country_name: "Argentina",
      region_code: "C",
      region_name: "Buenos Aires F.D.",
      city: "Buenos Aires",
      zip_code: "1871",
      time_zone: "America/Argentina/Buenos_Aires",
      latitude: -34.6033,
      longitude: -58.3816,
      metro_code: 0
    }
    
    #Make sure the country is in countries table
    sql = "INSERT INTO countries (iso_code, country_name, languages) VALUES (?, ?, ?)"
    Country.db[sql, @geo_data["country_code"], @geo_data["country_name"], "es-AR,en,it"].insert 

    #Avoid external HTTP requests
    FreeGeoIP.expects(:geolocate).returns(@geo_data)
  end

  it 'should set the country from geo data (201 Created)' do
    attrs = { "message" => "Hello" }

    json_post "/", attrs

    assert_equal 201, last_response.status

    body = JSON.parse(last_response.body)

    assert_equal "#{attrs["message"]} from #{@geo_data[:country_name]}", body["message"]
  end

  it 'should find the language if not specified (201 Created)' do
    assert 0, Message.count

    json_post "/", { "message" => "Hello" }

    message = Message.first

    assert_equal 201, last_response.status
    assert !message.language.empty?
  end

  it 'should set the language if specified (201 Created)' do
    assert 0, Message.count

    json_post "/", { "message" => "Hello", "lang" => "en-US" }

    message = Message.first

    assert_equal 201, last_response.status
    assert_equal "en-US", message.language
  end

  it 'should reject any other than a JSON request (400 Bad Request)' do
    attrs = { "message" => "Hello" }

    post "/", attrs, { "CONTENT_TYPE" => "application/x-form-urlencoded" } 

    assert_equal 400, last_response.status

    body = JSON.parse(last_response.body)

    assert_equal "Bad Request", body["message"]
  end

  it 'should not accept empty message (422 Unprocessable Entity)' do
    json_post "/", { "message" => "" }

    assert_equal 422, last_response.status
    body = JSON.parse(last_response.body)

    assert_equal "Unprocessable Entity", body["message"]
    assert_equal ["not_present"], body["errors"]["body"]
  end
end
