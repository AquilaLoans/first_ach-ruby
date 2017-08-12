# frozen_string_literal: true

module FirstACH
  module Customer
    # Customer Account
    class Account
      include FirstACH::XML

      AUTH_FORM_OPTIONS  = { single_payment: 'Single Payment/Series', until_revoked: 'Until Revoked' }.freeze
      AUTH_VOICE_OPTIONS = [:consumer_inititated_call, :existing_relationship].freeze
      ACCOUNT_TYPES      = [:business_checking, :personal_checking, :personal_savings].freeze

      SCHEMA = [
        :customerToken, :accountName, :accountType, :routingNumber, :accountNumber, :isDefault,
        :bankName, :bankCity, :bankState, :authOptionForm, :authOptionVoice, :authDate
      ].freeze

      # Create Customer Account
      # @param customer_token    [String - Alphanumeric 50] Tokenized reference to an existing Customer Profile
      # @param name              [String - Alphanumeric 50] Title of Account; e.g., "Primary Checking"
      # @param type              [Symbol]                   See ACCOUNT_TYPES
      # @param routing_number    [String - Numeric 9]       Routing Number of Bank Account
      # @param account_number    [String - Numeric 17]      Bank Account Number
      # @param is_default        [Boolean]                  Default Account for a given Customer (utilized in Web Interface). Each Customer may have only one default Account
      # @param bank_name         [String - Alphanumeric 50] Name of Bank; e.g., "SunTrust"
      # @param bank_city         [String - Alpha 50]        City of Bank of Account
      # @param bank_state        [String - Alpha 2]         Valid 2-character state abbreviation
      # @param auth_option_form  [Symbol]                   Signed Form authorization option. Required for SECCType CCD or PPD. See AUTH_FORM_OPTIONS
      # @param auth_option_voice [Symbol]                   Recorded Voice authorization option. Required for SECCType TEL. Accepts: `:consumer_inititated` or `:existing_relationship`
      # @param auth_date         [Date]                     Date of Authorization
      def self.create(customer_token:, name: nil, type:, routing_number:, account_number:,
                      is_default: nil, bank_name: nil, bank_city: nil, bank_state: nil, auth_option_form: nil,
                      auth_option_voice: nil, auth_date:)

        parameters                   = arguments(__method__, binding)
        parameters[:accountName]     = parameters.delete(:name)
        parameters[:accountType]     = parameters.delete(:type).to_s.titleize
        parameters[:isDefault]       = (parameters.delete(:isDefault) ? 1 : 0) unless parameters[:isDefault].nil?
        parameters[:authDate]        = parameters.delete(:authDate)&.to_date&.strftime('%Y-%m-%d')
        parameters[:authOptionForm]  = AUTH_FORM_OPTIONS[parameters.delete(:authOptionForm)]
        parameters[:authOptionVoice] = parameters.delete(:authOptionVoice).to_s.titleize
        parameters                   = SCHEMA.map { |key| [key, parameters[key]] }

        payload = build_document('createCustomerAccount') do |document|
          build_object(document, 'account', parameters)
        end

        FirstACH::Client.execute(:post, payload)
      end

      # UpdateCustomerAccount
      # DeleteCustomerAccount
    end
  end
end
