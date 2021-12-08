require 'rails_helper'

RSpec.describe 'Merchant Requests' do
  before do
    @merchant1 = Merchant.create(name: 'merchant1')
    @merchant2 = Merchant.create(name: 'merchant2')
    @merchant3 = Merchant.create(name: 'merchant3')
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

  it "can get one merchant by its id" do
    get "/api/v1/merchants/#{@merchant1.id}"
  
    merchant = JSON.parse(response.body, symbolize_names: true)
  
    expect(response).to be_successful
    expect(merchant[:data][:id]).to eq(@merchant1.id.to_s)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end
end