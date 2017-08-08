# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FirstACH do
  describe '#configure' do
    let(:new_config) { { secret: '#configure-secret' } }

    context 'without block' do
      before(:each) do
        described_class.configure(described_class::Configuration.new(new_config))
      end

      xit 'sets the configuration based on param' do
        expect(described_class.configuration.secret).to eql new_config[:secret]
      end
    end

    context 'with block' do
      before(:each) do
        described_class.configure do |config|
          config.secret = new_config[:secret]
        end
      end

      xit 'sets configuration based on the block' do
        expect(described_class.configuration.secret).to eql new_config[:secret]
      end
    end
  end
end
