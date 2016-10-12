require_relative '../test_helper'

describe 'Get Messages' do
  describe 'Mixed languages' do
    before do
      3.times do
        Message.create(body: "Test", language: %w(es-AR en-US).sample)
      end
    end

    it 'should return max messages by default (200 OK)' do
      get "/"

      assert_equal 200, last_response.status

      body = JSON.parse(last_response.body)

      assert_equal Message.count, body["messages"].size
    end

    it 'should limit the number of results by parameter (200 OK)' do
      get "/", { limit: 2 }

      assert_equal 200, last_response.status

      body = JSON.parse(last_response.body)

      assert_equal 2, body["messages"].size
    end

    it 'should require numeric limit (400 Bad Request)' do
      get "/", { limit: "non-numeric" }

      assert_equal 400, last_response.status

      body = JSON.parse(last_response.body)

      assert_equal "Limit must be a number", body["message"]
    end
  end

  describe 'Filtered by language' do
    before do
      3.times do
        Message.create(body: "Test", language: "es-AR")
      end

      3.times do
        Message.create(body: "Test", language: "en-US")
      end

      it 'should filter by language' do
        get "/", { lang: "es-AR" }

        assert_equal 200, last_response.status

        body = JSON.parse(last_response.body)

        assert_equal 6, Message.count
        assert_equal 3, body["messages"].size

        body["messages"].each do |msg|
          assert_equal "es-AR", msg["language"]
        end
      end
    end
  end

  describe 'Sorted by creation date' do
    before do
      Message.create(body: "Test", language: "es-AR", created_at: '2016-01-01')
      Message.create(body: "Test", language: "en-US", created_at: '2016-02-01')
      Message.create(body: "Test", language: "es-AR", created_at: '2016-03-01')
      Message.create(body: "Test", language: "en-US", created_at: '2016-04-01')
      Message.create(body: "Test", language: "es-AR", created_at: '2016-05-01')
    end

    it 'should should newer messages first' do
      get '/'

      assert_equal 200, last_response.status

      body = JSON.parse(last_response.body)

      assert_equal '2016-05-01', Date.parse(body["messages"][0]["created_at"]).to_s
      assert_equal '2016-04-01', Date.parse(body["messages"][1]["created_at"]).to_s
      assert_equal '2016-03-01', Date.parse(body["messages"][2]["created_at"]).to_s
      assert_equal '2016-02-01', Date.parse(body["messages"][3]["created_at"]).to_s
      assert_equal '2016-01-01', Date.parse(body["messages"][4]["created_at"]).to_s
    end
  end
end
