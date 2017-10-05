# frozen_string_literal: true

module FirstACH
  # Configuration
  class Configuration < OpenStruct
    DEFAULTS = {
      environment:     'demo',
      login_id:        nil,
      transaction_key: nil,
      timeout:         60
    }.freeze

    # Creates a new Configuration from the passed in parameters
    # @param params [Hash] configuration options
    # @return [Configuration]
    def initialize(params = {})
      super(DEFAULTS.merge(params))
    end
  end
end
