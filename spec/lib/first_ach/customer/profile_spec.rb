# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FirstACH::Customer::Profile do
  include_context 'configure'

  let(:parameters) do
    {
      name: 'Joe Customer',
      id: 'UG10910',
      address: '1600 Pennsylvania Ave',
      city: 'Washington',
      state: 'DC',
      zip: '20036',
      phone: '202-555-1212',
      email: 'anycustomer@nextdayfunding.com',
      fax: '202-555-0000',
      driver_licence_id: 'UG1-H2-H3-009L-91',
      driver_licence_state: 'DC'
    }
  end

  describe '.create' do
    let(:schema)  { File.read(File.expand_path('../../../../support/schemas/create_customer_profile.xml', __FILE__)) }
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

    it 'returns a profile' do
      expect(request.customer).to be_an OpenStruct
    end
  end
end
