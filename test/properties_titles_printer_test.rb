# frozen_string_literal: true

require "minitest/autorun"
require "minitest/mock"
require "property"
require "properties_titles_printer"

class PropertiesTitlesPrinterTest < Minitest::Test
  def setup
    @logger = Logger.new(nil)
    @first_page_response = {
      properties: [
        Property.new(title: "Property 1"),
        Property.new(title: "Property 2"),
        Property.new(title: "Property 3"),
      ],
      next_page: "next_page_url",
    }
    @second_page_response = {
      properties: [
        Property.new(title: "Property 4"),
      ],
      next_page: nil,
    }
  end

  def test_print_all_properties_titles
    mock_api_client = Minitest::Mock.new
    mock_api_client.expect(:fetch_properties, @first_page_response, page: 1)
    mock_api_client.expect(:fetch_properties, @second_page_response, page: 2)
    printer = PropertiesTitlesPrinter.new(api_client: mock_api_client, logger: @logger)

    output = capture_io do
      printer.print_all_properties_titles
    end

    assert_equal "Property 1\nProperty 2\nProperty 3\nProperty 4\n", output[0]
    mock_api_client.verify
  end

  def test_print_all_properties_titles_with_api_client_exception
    mock_api_client = Minitest::Mock.new
    mock_api_client.expect(:fetch_properties, @first_page_response, page: 1)
    mock_api_client.expect(:fetch_properties, proc { raise StandardError.new("API Error") }, page: 2)

    printer = PropertiesTitlesPrinter.new(api_client: mock_api_client, logger: @logger)

    output = capture_io do
      printer.print_all_properties_titles
    end

    assert_equal "Property 1\nProperty 2\nProperty 3\n", output[0]
    mock_api_client.verify
  end
end
