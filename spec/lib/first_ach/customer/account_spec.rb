# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FirstACH::Customer::Account do
  include_context 'configure'

  let(:parameters) do
    {
      customer_token: 'vsVKWkEMolinPO0/YVGPLg==',
      name: 'New Account',
      type: :personal_checking,
      routing_number: '111111118',
      account_number: '9876543210',
      is_default: true,
      bank_name: 'Capital One',
      bank_city: 'Mitchellville',
      bank_state: 'MD',
      authorization_type: :until_revoked,
      authorization_option_voice: :existing_relationship,
      authorized_on: Date.parse('2011-03-05')
    }
  end

  describe '.create' do
    let(:schema)  { File.read(File.expand_path('../../../../support/schemas/create_customer_account.xml', __FILE__)) }
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

    it 'returns an account_token' do
      expect(request.account_token).to be_an String
    end

    it 'returns a customer_token' do
      expect(request.customer_token).to be_an String
    end
  end
end
