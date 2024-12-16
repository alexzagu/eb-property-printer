# frozen_string_literal: true

require "minitest/autorun"
require "property"

class PropertyTest < Minitest::Test
  def test_from_hash_with_empty_hash
    assert_nil Property.from_hash
  end

  def test_from_hash_without_title
    assert_nil Property.from_hash({ "key": "value" })
  end

  def test_from_hash_with_title
    property_title = "Test Title"
    property = Property.from_hash({ "title": property_title })
    refute_nil property
    assert_equal property.title, property_title
  end
end
