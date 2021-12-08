require 'rails_helper'

RSpec.describe 'Item Merchants' do
  before do
    @merchant = Merchant.create(name: 'Merchant')
    @item1 = Item.create!(merchant_id: @merchant.id, name: 'Item1', description: 'It is an item', unit_price: 5.0)
  end
  it 'gets all of a items merchant information' do
    get "/api/v1/items/#{@item1.id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data][:id]).to be_an(String)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end
end