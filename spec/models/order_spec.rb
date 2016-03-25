require 'spec_helper'
require_relative '../../models/order'

describe 'Order' do
  it 'should have all required attributes' do
    order = Order.new

    %i(id size extras_list pickup_time coffee).each do |attr|
      expect(order).to respond_to(attr)
    end
  end

  describe '#extras' do
    it 'returns the parsed contents of the extras_list' do
      order = Order.new
      order.extras_list = '["sugar"]'
      expect(order.extras).to eq(['sugar'])
    end
  end

  describe '#extras=' do
    it 'updates the extras_list' do
      order = Order.new
      expect { order.extras = ['vanilla'] }.to change{ order.extras_list }
    end
  end

  describe '#status' do
    let(:coffee) { double("coffee", brewing_time: 20) }

    it 'returns READY if the pickup time is in the past' do
      order = Order.new(coffee: coffee, pickup_time: Time.now - 60)
      expect(order.status).to eq('READY')
    end

    it 'returns MAKING if the pickup time is in the near future' do
      order = Order.new(coffee: coffee, pickup_time: Time.now + 30)
      expect(order.status).to eq('MAKING')
    end

    it 'returns QUEUED if the pickup time is in the distant future' do
      order = Order.new(coffee: coffee, pickup_time: Time.now + 120)
      expect(order.status).to eq('QUEUED')
    end
  end
end
