# frozen_string_literal: true

module FirstACH
  module Payment
    # Payment Return
    class Status
      include FirstACH::XML

      # Get Payment status for a given payment_id
      # @param payment_id     [Date]    Date of returned payments.
      def self.create(payment_id)
        payment_parameters  = { paymentID:  payment_id}

        payload = build_document('getCustomerPaymentByID') do |document|
          build_object(document, 'payment', payment_parameters)
        end

        FirstACH::Client.execute(:post, payload)
      end
    end
  end
end
