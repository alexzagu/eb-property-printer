# frozen_string_literal: true

require "net/http"
require "json"
require "logger"
require_relative "property"

# Handles API communication for fetching properties with rate limiting
class APIClient
  def initialize(base_url:, api_key:, logger: nil)
    @base_url = base_url
    @api_key = api_key
    @logger = logger || Logger.new(STDOUT)
    @last_request_time = nil
  end

  def fetch_properties(page: 1, limit: 50)
    enforce_rate_limit

    uri = URI("#{@base_url}/properties?page=#{page}&limit=#{limit}")

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
      request = Net::HTTP::Get.new(uri)
      request["accept"] = "application/json"
      request["X-Authorization"] = @api_key
      http.request(request)
    end

    case response.code.to_i
    when 200
      parse_successful_properties_response(response.body)
    when 400
      raise ArgumentError, "Invalid parameters"
    when 401
      raise SecurityError, "Invalid or missing API key"
    else
      raise StandardError, "Unexpected API response: #{response.code}"
    end
  end

  private

  def enforce_rate_limit
    # Ensure at least 50ms between requests (20 requests per second)
    if @last_request_time
      wait_time = 0.05 - (Time.now - @last_request_time)
      sleep(wait_time) if wait_time > 0
    end

    @last_request_time = Time.now
  rescue StandardError => e
    @logger.error("Rate limiting error: #{e.message}")
  end

  def parse_successful_properties_response(body)
    parsed_response = JSON.parse(body)

    properties = parsed_response["content"]
      .map(&Property.method(:from_hash))
      .compact

    {
      properties: properties,
      next_page: parsed_response["pagination"]["next_page"]
    }
  end
end
