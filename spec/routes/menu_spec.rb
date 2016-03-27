require 'spec_helper'
require 'json'
require_relative '../../models/coffee'

describe 'GET /menu' do
  it 'should return a status of 200' do
    get '/menu'

    expect(last_response.status).to eq(200)
  end

  it 'should return a JSON object containing a list of coffees' do
    get '/menu'

    result = JSON.parse(last_response.body)

    expect(result[:coffees]).to be_a(Array)
  end
end
