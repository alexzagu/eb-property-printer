require "logger"
require_relative "lib/api_client"
require_relative "lib/properties_titles_printer"

logger = Logger.new(STDOUT)
logger.level = Logger::INFO

api_client = APIClient.new(
  base_url: "https://api.stagingeb.com/v1",
  api_key: ENV["EB_API_KEY"] || "",
  logger:
)

printer = PropertiesTitlesPrinter.new(api_client:, logger:)
printer.print_all_properties_titles
