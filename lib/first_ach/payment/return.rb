# frozen_string_literal: true

module FirstACH
  module Payment
    # Payment Return
    class Return
      include FirstACH::XML

      # Get Returned Payments for a given date
      # @param return_date     [Date]    Date of returned payments.
      def self.create(return_date: nil)
        payment_parameters  = { returnDate:  return_date&.to_date&.strftime('%m/%d/%Y')}

        payload = build_document('getReturns') do |document|
          build_object(document, 'paymentDetail', payment_parameters)
        end

        FirstACH::Client.execute(:post, payload)
      end
    end
  end
end
