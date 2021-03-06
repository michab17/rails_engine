require 'rails_helper'

RSpec.describe 'Merchant Requests' do
  before do
    @merchant1 = Merchant.create(name: 'Billy')
    @merchant2 = Merchant.create(name: 'Kevin')
    @merchant3 = Merchant.create(name: 'Richie')
  end
  it 'gets a list of all merchants' do
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    merchants[:data].each do |merchant|
      expect(merchant[:id]).to be_an(String)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'can get one merchant by its id' do
    get "/api/v1/merchants/#{@merchant1.id}"
  
    merchant = JSON.parse(response.body, symbolize_names: true)
  
    expect(response).to be_successful
    expect(merchant[:data][:id]).to eq(@merchant1.id.to_s)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

  it 'can find one merchant by name search' do
    get "/api/v1/merchants/find?name=Billy"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant[:data][:id]).to eq(@merchant1.id.to_s)
    expect(merchant[:data][:attributes][:name]).to eq(@merchant1.name)
  end

  it 'can find all merchants by name search' do
    get "/api/v1/merchants/find_all?name=i"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant[:data][0][:id]).to eq(@merchant1.id.to_s)
    expect(merchant[:data][0][:attributes][:name]).to eq(@merchant1.name)
    expect(merchant[:data].last[:id]).to eq(@merchant3.id.to_s)
    expect(merchant[:data].last[:attributes][:name]).to eq(@merchant3.name)
  end

  it 'find: returns an error if name doesnt match' do
    get "/api/v1/merchants/find?name=thisisnotaname"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq 400
  end

  it 'find_all: returns an error if name doesnt match' do
    get "/api/v1/merchants/find_all?name=thisisnotaname"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq 400
  end
end