if ENV.fetch("COVERAGE", false)
  require "simplecov"
  SimpleCov.start "rails"
end

require "webmock/rspec"

if ENV["CODECLIMATE_REPO_TOKEN"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

# http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.example_status_persistence_file_path = "tmp/rspec_examples.txt"
  config.order = :random
end

WebMock.disable_net_connect!(allow_localhost: true, allow: ["codeclimate.com", "mandrillapp.com"])
