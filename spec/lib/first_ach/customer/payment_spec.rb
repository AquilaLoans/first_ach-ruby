# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FirstACH::Customer::Payment do
  include_context 'configure'

  let(:parameters) do
    {
      account_token: 'nLx8MUtHO711LFJFKeoLSw==',
      customer_token: 'vsVKWkEMolinPO0/YVGPLg==',
      secc_type: :ppd,
      type: :debit,
      amount: 450.99,
      frequency: :monthly,
      number_of_payments: 2,
      memo: 'Loan repayment',
      is_private: true
    }
  end

  describe '.create' do
    let(:schema) { File.read(File.expand_path('../../../../support/schemas/create_customer_payment.xml', __FILE__)) }
    let(:request) { described_class.create(parameters) }

    it 'invokes a post request with a well formed document' do
      FirstACH.configure do |config|
        config.login_id        = 'LOGIN_ID'
        config.transaction_key = 'TRANSACTION_KEY'
      end

      expect(FirstACH::Client).to receive(:execute).with(:post, schema.to_s)
      request
    end

    it 'returns an OpenStruct' do
      expect(request).to be_an OpenStruct
    end

    it 'returns a payment' do
      expect(request.payment).to be_an OpenStruct
    end
  end
end
