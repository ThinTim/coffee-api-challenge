require 'spec_helper'
require_relative '../../models/coffee'

describe 'Coffee' do
  it 'should have all required attributes' do
    coffee = Coffee.new

    %i(id name price caffeine_level milk_ratio).each do |attr|
      expect(coffee).to respond_to(attr)
    end
  end
end
