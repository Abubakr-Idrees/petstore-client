# Petstore API Client

A production-quality Ruby client library for the [Swagger Petstore API](https://petstore.swagger.io/v2). This library provides a clean, idiomatic Ruby interface for managing pets and store orders.

## Features

✅ All 7 required API endpoints implemented
✅ Request validation with detailed error messages
✅ API key authentication support
✅ Comprehensive error handling
✅ Integration tests (10 test cases, all passing)
✅ Clean OOP design with model objects

## Requirements

- Ruby >= 3.2.9
- Bundler

## Installation
```bash
# Clone the repository
git clone https://github.com/Abubakr-Idrees/petstore-client.git
cd petstore-client

# Install dependencies
bundle install
```

## Quick Start
```ruby
require_relative 'lib/petstore_client'

# Initialize client with API key (optional)
client = PetstoreClient::Client.new do |config|
  config.api_key = 'special-key'
end

# Create a pet
pet = PetstoreClient::Models::Pet.new(
  name: 'Buddy',
  photo_urls: ['https://example.com/buddy.jpg'],
  status: 'available'
)

created_pet = client.pet.create_pet(pet)
puts "Created pet: #{created_pet.name} (ID: #{created_pet.id})"
```

## API Endpoints

### Pet Endpoints

**1. Create a Pet**
```ruby
category = PetstoreClient::Models::Category.new(id: 1, name: 'Dogs')
pet = PetstoreClient::Models::Pet.new(
  name: 'Fido',
  photo_urls: ['https://example.com/fido.jpg'],
  category: category,
  status: 'available'
)

client.pet.create_pet(pet)
```

**2. Update a Pet**
```ruby
pet.status = 'sold'
client.pet.update_pet(pet)
```

**3. Get Pet by ID**
```ruby
pet = client.pet.get_pet_by_id(123)
puts pet.name
```

**4. Delete a Pet**
```ruby
client.pet.delete_pet(123)
```

### Store Endpoints

**1. Place an Order**
```ruby
order = PetstoreClient::Models::Order.new(
  id: 987,
  pet_id: 123,
  quantity: 2,
  ship_date: '2025-01-02T10:00:00Z',
  status: 'placed',
  complete: false
)

client.store.place_order(order)
```

**2. Get Order by ID**
```ruby
order = client.store.get_order_by_id(987)
puts "Order #{order.id}: #{order.quantity} items"
```

**3. Delete an Order**
```ruby
client.store.delete_order(987)
```

## Configuration
```ruby
client = PetstoreClient::Client.new do |config|
  # Optional: Add API key for authentication
  config.api_key = 'special-key'
  
  # Optional: Change base URL (default: https://petstore.swagger.io/v2)
  config.base_url = 'https://petstore.swagger.io/v2'
  
  # Optional: Set timeouts
  config.timeout = 60          # Request timeout in seconds
  config.open_timeout = 10     # Connection timeout in seconds
end
```

## Error Handling
```ruby
begin
  pet = client.pet.get_pet_by_id(123)
rescue PetstoreClient::ValidationError => e
  # Client-side validation failed
  puts "Validation error: #{e.message}"
rescue PetstoreClient::NotFoundError => e
  # Resource not found (404)
  puts "Not found: #{e.message}"
rescue PetstoreClient::InvalidRequestError => e
  # Invalid request (400, 405)
  puts "Invalid request: #{e.message}"
rescue PetstoreClient::ConnectionError => e
  # Network error
  puts "Connection failed: #{e.message}"
rescue PetstoreClient::ApiError => e
  # Other API errors
  puts "API error: #{e.message} (Status: #{e.status_code})"
end
```

## Running Tests
```bash
# Run all tests
bundle exec rspec

# Run with detailed output
bundle exec rspec --format documentation

# Run integration tests only
bundle exec rake integration
```

**Expected output:**
```
Pet API Integration Tests
  POST /pet - Create Pet
    ✓ creates a pet successfully
    ✓ raises ValidationError when name is missing
    ✓ raises ValidationError when photo_urls is empty
  GET /pet/{petId} - Get Pet by ID
    ✓ returns the pet
    ✓ raises NotFoundError
  DELETE /pet/{petId} - Delete Pet
    ✓ deletes the pet successfully

Store API Integration Tests
  POST /store/order - Place Order
    ✓ places an order successfully
  GET /store/order/{orderId} - Get Order by ID
    ✓ returns the order
    ✓ raises NotFoundError
  DELETE /store/order/{orderId} - Delete Order
    ✓ deletes the order successfully

10 examples, 0 failures
```

## Project Structure
```
petstore-client/
├── lib/
│   ├── petstore_client.rb              # Main entry point
│   └── petstore_client/
│       ├── client.rb                    # Main client class
│       ├── configuration.rb             # Configuration management
│       ├── errors.rb                    # Error classes
│       ├── models/
│       │   ├── pet.rb                   # Pet model with validation
│       │   ├── order.rb                 # Order model
│       │   ├── category.rb              # Category model
│       │   ├── tag.rb                   # Tag model
│       │   └── api_response.rb          # API error response model
│       └── api/
│           ├── base_api.rb              # Base HTTP client
│           ├── pet_api.rb               # Pet endpoint implementations
│           └── store_api.rb             # Store endpoint implementations
├── spec/
│   ├── spec_helper.rb                   # RSpec configuration
│   └── integration/
│       ├── pet_api_spec.rb              # Pet API tests
│       └── store_api_spec.rb            # Store API tests
├── Gemfile                              # Dependencies
├── Rakefile                             # Task definitions
└── README.md                            # This file
```

## Design Decisions

### 1. Architecture
- **Separation of Concerns**: Models, API classes, and client are separate
- **Inheritance**: PetApi and StoreApi inherit from BaseApi
- **Configuration Object**: Centralized configuration management

### 2. Validation
- Client-side validation before API calls (Pet model)
- Type checking for IDs
- Status enum validation
- Reduces unnecessary API calls

### 3. Error Handling
- Specific error classes for different scenarios
- Errors include status codes and response bodies
- Network errors wrapped in ConnectionError

### 4. Testing
- Integration tests using WebMock (no real API calls)
- Tests cover success and error scenarios
- Fast execution and deterministic results

### 5. HTTP Client
- Uses Faraday for flexibility
- JSON serialization/deserialization automatic
- Configurable timeouts

## Dependencies

- **faraday** (~> 2.7) - HTTP client
- **faraday-multipart** (~> 1.0) - Multipart support
- **rspec** (~> 3.12) - Testing framework
- **webmock** (~> 3.18) - HTTP mocking for tests
- **rake** (~> 13.0) - Task automation
- **pry** (~> 0.14) - Debugging console

## Assignment Requirements

✅ **Runnable client library**
✅ **All 7 endpoints implemented** (4 Pet + 3 Store)
✅ **Models for request/response structures**
✅ **Validation rules enforced**
✅ **Integration tests** (success + error scenarios)
✅ **Complete documentation**
✅ **Setup/install instructions**
✅ **Usage examples**
✅ **Test execution instructions**
✅ **Design decisions documented**

### Bonus Features
✅ **API key authentication**
✅ **Production-ready** (timeouts, error handling)

## Author

Built for APIMatic Senior Software Engineer Technical Assessment

## Repository

https://github.com/Abubakr-Idrees/petstore-client
