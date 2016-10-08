require_relative '../test_helper'

describe 'Validators::Message' do
  before do
    @valid_attributes = { 
      "body"     => "Test message",
      "language" => "en-US",
      "country"  => "Argentina"
    }
  end

  it 'should require message body' do
    attrs = @valid_attributes.dup
    attrs.delete("body")

    validator = Validators::Message.new(attrs)

    assert !validator.valid?
    assert_equal [:not_present], validator.errors[:body]
  end

  it 'should require message language' do
    attrs = @valid_attributes.dup
    attrs.delete("language")

    validator = Validators::Message.new(attrs)

    assert !validator.valid?
    assert_equal [:not_present], validator.errors[:language]
  end

  it 'should allow empty country' do
    attrs = @valid_attributes.dup
    attrs.delete("country")

    validator = Validators::Message.new(attrs)

    assert validator.valid?
  end
end
