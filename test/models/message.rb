require_relative '../test_helper'

describe 'Message' do
  before do
    words    = %w(some words to create messages randomly)
    countries = %w(Argentina UnitedStates Netherlands)

    #es-AR
    3.times do
      Message.create(body: words.sample, country: countries.sample, language:  "es-AR")
    end

    #en-US
    3.times do
      Message.create(body: words.sample, country: countries.sample, language:  "en-US")
    end
    
  end

  it 'should filter by language' do
    messages = Message.search(language: "es-AR")

    assert_equal 3, messages.count
  end

  it 'should limit the amount of results' do
    messages = Message.search(language: "es-AR", limit: 2)

    assert_equal 2, messages.count
  end

  it 'should filter by partial locale' do
    Message.create(body: "Test", language: "es-ES")

    messages = Message.search(language: "es")

    assert_equal 4, messages.count
  end

  it 'should return all messages by default' do
    assert_equal Message.count, Message.search.count
  end

  it 'should limit results even when no filter' do
    messages = Message.search(limit: 2)

    assert_equal 2, messages.count
    assert Message.count > messages.count
  end
end
