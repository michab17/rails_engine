require 'rails_helper'

RSpec.describe 'Item Requests' do
  before do
    @merchant = Merchant.create(name: 'Merchant')
    @item1 = Item.create!(merchant_id: @merchant.id, name: 'Item1', description: 'It is an item', unit_price: 5.0)
    @item2 = Item.create!(merchant_id: @merchant.id, name: 'Item2', description: 'It is a another item', unit_price: 10.0)
    @item3 = Item.create!(merchant_id: @merchant.id, name: 'Item3', description: 'It is yet another item', unit_price: 15.0)
    @merchant2 = Merchant.create(name: 'Merchant')
    @item4 = Item.create!(merchant_id: @merchant2.id, name: 'Item4', description: 'It is an item', unit_price: 5.0)
    @item5 = Item.create!(merchant_id: @merchant2.id, name: 'Item5', description: 'It is a another item', unit_price: 10.0)
    @item6 = Item.create!(merchant_id: @merchant2.id, name: 'Item6', description: 'It is yet another item', unit_price: 15.0)
  end
  it 'gets a list of all items' do
    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items.count).to eq 6

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(Integer)

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)
    end
  end

  it 'gets a one item with its id' do
    get "/api/v1/items/#{@item1.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item.count).to eq 1

    expect(item).to have_key(:id)
    expect(item[:id]).to be_an(Integer)

    expect(item).to have_key(:name)
    expect(item[:name]).to be_a(String)

    expect(item).to have_key(:description)
    expect(item[:description]).to be_a(String)

    expect(item).to have_key(:unit_price)
    expect(item[:unit_price]).to be_a(Float)
  end
end