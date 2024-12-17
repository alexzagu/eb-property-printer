# EasyBroker Real Estate Property Printer

## Overview

This Ruby application fetches and prints real estate properties from a paginated API, with built-in rate limiting and error handling.

## Features

- Paginated API property retrieval
- Rate limiting (20 requests per second)
- Comprehensive error handling
- Logging support
- Extensive unit testing

## Prerequisites

- Ruby 3.2+ (recommended)

## Configuration

Set your API key as an environment variable:
```bash
export EB_API_KEY="your_api_key_here"
```

## Running the Application

### Run the Main Script
```bash
rake
# or
rake run
```

### Run Tests
```bash
rake test
```

## Project Structure

- `lib/`: Core application code
- `test/`: Unit tests
- `main.rb`: Entry point for the application
- `Rakefile`: Task automation

## Customization

- Modify `main.rb` to change API endpoint or logging behavior
- Adjust rate limiting in `APIClient` as needed

## Potential Improvements

- Implement a retry mechanism for failed fetch requests, such as exponential backoff
- Use multiple threads to make page fetching concurrent