# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FirstACH::Error do
  let(:instance) { described_class.new(OpenStruct.new(code: 'CODE', text: 'TEXT', message: 'MESSAGE')) }

  describe '#code' do
    it 'returns the response code' do
      expect(instance.code).to eq 'CODE'
    end
  end

  describe '#text' do
    it 'returns the response text' do
      expect(instance.text).to eq 'TEXT'
    end
  end

  describe '#message' do
    it 'returns the response message' do
      expect(instance.message).to eq 'MESSAGE'
    end
  end

  describe '#to_s' do
    it 'returns the response code' do
      expect(instance.to_s).to include 'CODE'
    end

    it 'returns the response message' do
      expect(instance.to_s).to include 'MESSAGE'
    end
  end
end
