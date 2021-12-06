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

    expect(merchants.count).to eq 3

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(Integer)

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end
  end

  it "can get one merchant by its id" do
    get "/api/v1/merchants/#{@merchant1.id}"
  
    merchant = JSON.parse(response.body, symbolize_names: true)
  
    expect(response).to be_successful
  
    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(@merchant1.id)
  
    expect(merchant).to have_key(:name)
    expect(merchant[:name]).to be_a(String)
  end
end