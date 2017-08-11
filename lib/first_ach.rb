# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/core_ext/string'
require 'rest-client'
require 'nokogiri'
require 'ostruct'

require 'first_ach/client'
require 'first_ach/configuration'
require 'first_ach/xml'

require 'first_ach/customer/account'
require 'first_ach/customer/payment'
require 'first_ach/customer/profile'
require 'first_ach/version'

module FirstACH
  class << self
    attr_reader :configuration
  end

  # Creates/sets a new configuration for the gem, yield a configuration object
  # @param new_configuration [Configuration] new configuration
  # @return [Configuration] the frozen configuration
  def self.configure(new_configuration = Configuration.new)
    yield(new_configuration) if block_given?

    @configuration = new_configuration.freeze
  end
end
