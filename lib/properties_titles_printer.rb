# frozen_string_literal: true

# Handles printing properties' titles
class PropertiesTitlesPrinter
  def initialize(api_client:, logger: nil)
    @api_client = api_client
    @logger = logger || Logger.new(STDOUT)
  end

  def print_all_properties_titles
    current_page = 1
    total_properties = 0

    loop do
      begin
        @logger.info("Fetching properties on page #{current_page}")
        result = @api_client.fetch_properties(page: current_page)

        @logger.info("Printing titles of properties on page #{current_page}")

        result[:properties].each do |property|
          puts property.title
          total_properties += 1
        end

        break if result[:next_page].nil?
        current_page += 1

      rescue StandardError, SecurityError, ArgumentError => e
        @logger.error("Error fetching properties on page #{current_page}: #{e.message}")
        break
      end
    end

    @logger.info("Finished printing properties' titles. Total properties: #{total_properties}")
  end
end
