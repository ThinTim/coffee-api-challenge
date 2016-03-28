require 'spec_helper'
require 'json'
require 'sequel'
require_relative '../../models/coffee'
require_relative '../../models/order'

describe 'POST /order/:coffee_id' do
  before(:each) do
    DB[:coffees].insert(id: "latte", name: "latte", price: 3.5, caffeine_level: 5, milk_ratio: 3, brewing_time: 30)
  end

  it 'should return a 404 status if the coffee does not exist' do
    post '/order/espresso'

    expect(last_response.status).to eq(404)
  end

  context 'pickup_time is specified' do
    it 'should return a 400 if the pickup time is too early' do
      pickup = Time.now + 10

      body = JSON.generate(size: 'small', extras: [], pickup_time: pickup)

      post 'order/latte', body

      expect(last_response.status).to eq(400)
    end

    it 'should create the order with the requested pickup time' do
      pickup = Time.now + 120

      body = JSON.generate(size: 'small', extras: [], pickup_time: pickup)

      post 'order/latte', body

      response = JSON.parse(last_response.body)

      order_id = response[:order].scan(/\d+/).first

      expect(Order.with_pk(order_id).pickup_time).to eq(pickup)
    end
  end

  it 'should return the order path in a JSON object if the order is valid' do
    body = JSON.generate(size: 'small', extras: [])

    post 'order/latte', body

    response = JSON.parse(last_response.body)

    expect(response[:order]).to match(/\/order\/\d+/)
  end
end

describe 'GET /order/:order_id' do
  before(:each) do
    DB[:coffees].insert(id: "latte", name: "latte", price: 3.5, caffeine_level: 5, milk_ratio: 3, brewing_time: 30)
    DB[:orders].insert(coffee_id: 'latte', size: 'small', extras_list: '[]', pickup_time: Time.now + 60)
  end

  it 'should return a 404 if the order does not exist' do
    get '/order/9999999999'

    expect(last_response.status).to eq(404)
  end

  it 'should return the status of the order if it exists' do
    get "order/#{Order.first.id}"

    response = JSON.parse(last_response.body)

    expect(response.status).to be_a(String)
  end
end
