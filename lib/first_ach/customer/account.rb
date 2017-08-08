# frozen_string_literal: true

module FirstACH
  module Customer
    class Account
      include FirstACH::XML

      AUTH_FORM_OPTIONS  = { single_payment: 'Single Payment/Series', until_revoked: 'Until Revoked' }.freeze
      AUTH_VOICE_OPTIONS = { consumer_inititated: 'Consumer Initiated Call', existing_relationship: 'Existing Relationship' }.freeze

      # Create Customer Account
      # @param customer_token    [String - Alphanumeric 50] Tokenized reference to an existing Customer Profile
      # @param name              [String - Alphanumeric 50] Title of Account; e.g., "Primary Checking"
      # @param type              [String - Alpha]           Valid Account Type: Business Checking, Personal Checking, Personal Savings
      # @param routing_number    [String - Numeric 9]       Routing Number of Bank Account
      # @param account_number    [String - Numeric 17]      Bank Account Number
      # @param is_default        [Boolean]                  Default Account for a given Customer (utilized in Web Interface). Each Customer may have only one default Account
      # @param bank_name         [String - Alphanumeric 50] Name of Bank; e.g., "SunTrust"
      # @param bank_city         [String - Alpha 50]        City of Bank of Account
      # @param bank_state        [String - Alpha 2]         Valid 2-character state abbreviation
      # @param auth_option_form  [Symbol]                   Signed Form authorization option. Required for SECCType CCD or PPD. Accepts: `:single_payment` or `:until_revoked`
      # @param auth_option_voice [Symbol]                   Recorded Voice authorization option. Required for SECCType TEL.  Accepts: `:consumer_inititated` or `:existing_relationship`
      # @param auth_date         [Date]                     Date of Authorization
      def self.create(customer_token:, name: nil, type:, routing_number:, account_number:,
                      is_default: nil, bank_name: nil, bank_city: nil, bank_state: nil, auth_option_form: nil,
                      auth_option_voice: nil, auth_date:)

        parameters                   = arguments(__method__, binding)
        parameters[:accountName]     = parameters.delete(:name)
        parameters[:accountType]     = parameters.delete(:type)
        parameters[:isDefault]       = (parameters.delete(:isDefault) ? 1 : 0) unless parameters[:isDefault].nil?
        parameters[:authDate]        = parameters.delete(:authDate)&.to_date&.strftime('%Y-%m-%d')
        parameters[:authOptionForm]  = AUTH_FORM_OPTIONS[parameters.delete(:authOptionForm)]
        parameters[:authOptionVoice] = AUTH_VOICE_OPTIONS[parameters.delete(:authOptionForm)]

        build_document('createCustomerAccount') do |document|
          build_object(document, 'account', parameters)
        end
      end

      # UpdateCustomerAccount
      # DeleteCustomerAccount
    end
  end
end
