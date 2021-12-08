require 'rails_helper'

RSpec.describe 'Merchants Items Requests' do
  before do
    @merchant = Merchant.create(name: 'Merchant')
    @item1 = Item.create!(merchant_id: @merchant.id, name: 'Item1', description: 'It is an item', unit_price: 5.0)
    @item2 = Item.create!(merchant_id: @merchant.id, name: 'Item2', description: 'It is a another item', unit_price: 10.0)
    @item3 = Item.create!(merchant_id: @merchant.id, name: 'Item3', description: 'It is yet another item', unit_price: 15.0)
  end
  it 'gets all of a merchants items' do
    get "/api/v1/merchants/#{@merchant.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    items[:data].each do |item|
      expect(item[:id]).to be_a(String)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end
end