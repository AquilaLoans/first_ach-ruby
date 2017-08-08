# frozen_string_literal: true
# frozen_string_literal: true

module FirstACH
  module Customer
    class Payment
      include FirstACH::XML

      SECC_TYPES    = [:ccd, :ppd, :arc, :rck, :tel, :web].freeze
      PAYMENT_TYPES = [:credit, :debit].freeze
      FREQUENCIES   = [:once, :weekly, :biweekly, :monthly, :quarterly, :semiannually, :annually].freeze

      # Create Customer Payment
      # @param customer_token     [String]  References an existing Customer Profile
      # @param account_token      [String]  References an existing Customer Account
      # @param secc_type          [Symbol]  See SECC_TYPES
      # @param payment_type       [Symbol]  See PAYMENT_TYPES
      # @param amount_per_payment [Float]   A decimal amount greater than 0.00
      # @param effective_date     [Date]    Date the first Customer Payment is to be processed. If empty, first valid effecDate applied automatically.
      # @param frequency          [Symbol]  See FREQUENCIES, Defaults to :once
      # @param number_of_payments [Integer] 1-9998; Use 9999 for Open-Ended recurring Customer Payments. Defaults to 1
      # @param memo               [String]  Details of Customer Payment, Alphanumeric 255
      # @param is_private         [Boolean] Customer Name and Customer Payment Amount can only be seen by users with Private Payment permission in the user interface.
      def self.create(customerToken:, accountToken:, secc_type:, payment_type:, amount_per_payment:,
                      effective_date: nil, frequency: :once, number_of_payments: 1, memo: nil, is_private: false)

        payment_parameters                = arguments(__method__, binding)
        payment_parameters[:SECCType]     = payment_parameters.delete(:seccType).to_s.upcase
        payment_parameters[:paymentType]  = payment_parameters.delete(:paymentType).to_s.capitalize
        payment_parameters[:effecDate]    = payment_parameters.delete(:effective_date)&.to_date&.strftime('%Y-%m-%d')
        payment_parameters[:frequency]    = payment_parameters.delete(:frequency).to_s.capitalize
        payment_parameters[:isPrivate]    = payment_parameters.delete(:isPrivate) ? 1 : 0

        account_parameters  = { accountToken:  payment_parameters.delete(:accountToken) }
        customer_parameters = { customerToken: payment_parameters.delete(:customerToken) }

        build_document('createCustomerPayment') do |document|
          build_object(document, 'paymentDetail', payment_parameters)
          build_object(document, 'account',       account_parameters)
          build_object(document, 'customer',      customer_parameters)
        end
      end

      # CreateExRecurPayment
      # GetCustomerPaymentByID
      # GetCustomerPayments
      # VoidPayment
      # GetReturns
    end
  end
end
