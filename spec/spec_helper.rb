# frozen_string_literal: true

require 'simplecov'
require 'pry'

SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
SimpleCov.start do
  add_filter '/spec/'
end

require 'bundler/setup'
require 'dotenv/load'
require 'first_ach'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!

  config.default_formatter = 'doc' if config.files_to_run.one?

  # config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random
  Kernel.srand config.seed
end

require_relative 'support/vcr'

RSpec.shared_context 'configure', shared_context: :metadata do
  before(:each) do
    FirstACH.configure do |config|
      config.login_id        = ENV.fetch('FIRST_ACH_LOGIN_ID')
      config.transaction_key = ENV.fetch('FIRST_ACH_TRANSACTION_KEY')
    end
  end
end
