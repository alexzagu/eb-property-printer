# frozen_string_literal: true

# Represents a single real estate property
class Property
  attr_reader :title

  def initialize(title:)
    @title = title
  end

  def self.from_hash(hash = {})
    title = hash[:title] || hash["title"]
    return Property.new(title:) if title
    return nil
  end
end
