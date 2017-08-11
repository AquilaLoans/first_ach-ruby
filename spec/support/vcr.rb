# frozen_string_literal: true

require 'vcr'
require 'active_support/core_ext/string'

ENV['FIRST_ACH_LOGIN_ID']        = ENV.fetch('FIRST_ACH_LOGIN_ID',    'FIRST_ACH_LOGIN_ID')
ENV['FIRST_ACH_TRANSACTION_KEY'] = ENV.fetch('FIRST_ACH_TRANSACTION_KEY', 'FIRST_ACH_TRANSACTION_KEY')

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock

  config.configure_rspec_metadata!

  config.filter_sensitive_data('FIRST_ACH_LOGIN_ID')        { ENV['FIRST_ACH_LOGIN_ID'] }
  config.filter_sensitive_data('FIRST_ACH_TRANSACTION_KEY') { ENV['FIRST_ACH_TRANSACTION_KEY'] }
end

RSpec.configure do |config|
  # Add VCR to all tests
  config.around(:each) do |example|
    options = example.metadata[:vcr] || {}

    if options[:record] == :skip
      VCR.turned_off(&example)
    else
      name = example
             .metadata[:full_description]
             .split(/\s+/, 2)
             .join('/')
             .underscore
             .strip
             .gsub(/[\.#]/, '/')
             .gsub(%r([^\w/]+), '_')
             .gsub(%(/$), '')
             .gsub('_/', '/')

      VCR.use_cassette(name, options, &example)
    end
  end
end
