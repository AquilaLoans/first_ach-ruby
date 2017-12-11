# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FirstACH::Payment::Return do
  include_context 'configure'

  let(:parameters) do
    {
        return_date: Date.parse('2011-03-05')
    }
  end

  describe '.create' do
    let(:schema) { File.read(File.expand_path('../../../../support/schemas/get_payment_returns.xml', __FILE__)) }
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
      expect(request).to be_an Array
    end
  end
end
