# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FirstACH::Client do
  include_context 'configure'

  describe '.execute' do
    context 'with error' do
      it 'raises an error' do
        allow(RestClient::Request).to receive(:execute).and_return(OpenStruct.new(body: 'BODY'))
        allow(FirstACH::Client).to receive(:parse_object).and_return(
          OpenStruct.new(messages: OpenStruct.new(
            code: 'ERROR_CODE',
            text: 'TEXT',
            message: 'MESSAGE'
          ))
        )

        expect { described_class.execute(:post, 'DOCUMENT') }.to raise_error(FirstACH::Error)
      end
    end
  end
end
