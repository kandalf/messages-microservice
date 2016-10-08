require_relative '../test_helper'

describe 'Presenters::Message' do
  it 'should include country in message' do
    msg = Message.new(body: "Hello", country: "Argentina", language: "en-US")

    presented = Presenters::Message.new(msg).to_hash

    assert_equal "#{msg.body} from #{msg.country}", presented[:message]
  end
end
