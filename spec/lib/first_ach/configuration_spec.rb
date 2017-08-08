# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FirstACH::Configuration do
  it { expect have_constant('DEFAULTS') }
end
