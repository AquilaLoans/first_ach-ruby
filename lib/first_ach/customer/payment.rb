# frozen_string_literal: true

module FirstACH
  module Customer
    # Customer Payment
    class Payment
      include FirstACH::XML

      TYPES         = [:credit, :debit].freeze
      SECC_TYPES    = [:ccd, :ppd, :arc, :rck, :tel, :web].freeze
      FREQUENCIES   = [:once, :weekly, :biweekly, :monthly, :quarterly, :semiannually, :annually].freeze

      SCHEMA = [
        :SECCType, :checkNo, :paymentType, :amountPerPayment, :effecDate, :frequency, :recurringDate,
        :numberOfPayments, :memo, :isPrivate, :custom1
      ].freeze

      # Create Customer Payment
      # @param customer_token     [String]  References an existing Customer Profile
      # @param account_token      [String]  References an existing Customer Account
      # @param secc_type          [Symbol]  See SECC_TYPES
      # @param type               [Symbol]  See TYPES
      # @param amount             [Float]   A decimal amount greater than 0.00
      # @param effective_date     [Date]    Date the first Customer Payment is to be processed. If empty, first valid effecDate applied automatically.
      # @param frequency          [Symbol]  See FREQUENCIES, Defaults to :once
      # @param recurring_date     [Date]    Date each Customer Payment is to be processed beginning with the second Payment in the series. If empty, recurringDate will be set according to the effecDate and frequency.
      # @param number_of_payments [Integer] 1-9998; Use 9999 for Open-Ended recurring Customer Payments. Defaults to 1
      # @param memo               [String]  Details of Customer Payment, Alphanumeric 255
      # @param is_private         [Boolean] Customer Name and Customer Payment Amount can only be seen by users with Private Payment permission in the user interface.
      def self.create(customer_token:, account_token:, secc_type:, type:, amount:, effective_date: nil,
                      frequency: :once, recurring_date: nil, number_of_payments: 1, memo: nil, is_private: false)

        payment_parameters                    = arguments(__method__, binding)
        payment_parameters[:SECCType]         = payment_parameters.delete(:seccType).to_s.upcase
        payment_parameters[:paymentType]      = payment_parameters.delete(:type).to_s.capitalize
        payment_parameters[:amountPerPayment] = payment_parameters.delete(:amount).to_s.capitalize
        payment_parameters[:effecDate]        = payment_parameters.delete(:effectiveDate)&.to_date&.strftime('%Y-%m-%d')
        payment_parameters[:frequency]        = payment_parameters.delete(:frequency).to_s.capitalize
        payment_parameters[:recurringDate]    = payment_parameters.delete(:recurringDate)&.to_date&.strftime('%Y-%m-%d')
        payment_parameters[:isPrivate]        = payment_parameters.delete(:isPrivate) ? 1 : 0

        account_parameters  = { accountToken:  payment_parameters.delete(:accountToken) }
        customer_parameters = { customerToken: payment_parameters.delete(:customerToken) }
        payment_parameters  = SCHEMA.map { |key| [key, payment_parameters[key]] }

        payload = build_document('createCustomerPayment') do |document|
          build_object(document, 'paymentDetail', payment_parameters)
          build_object(document, 'account',       account_parameters)
          build_object(document, 'customer',      customer_parameters)
        end

        FirstACH::Client.execute(:post, payload)
      end

      # CreateExRecurPayment
      # GetCustomerPaymentByID
      # GetCustomerPayments
      # VoidPayment
      # GetReturns
    end
  end
end
