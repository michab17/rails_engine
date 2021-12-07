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

    expect(item).to have_key(:id)
    expect(item[:id]).to be_an(Integer)

    expect(item).to have_key(:name)
    expect(item[:name]).to be_a(String)

    expect(item).to have_key(:description)
    expect(item[:description]).to be_a(String)

    expect(item).to have_key(:unit_price)
    expect(item[:unit_price]).to be_a(Float)
  end

  it 'can create a new item' do
    item_params = {
      merchant_id: @merchant.id,
      name: 'Item7',
      description: 'Is this the last item?',
      unit_price: 25.0
    }
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
  end

  it 'can edit an item' do
    new_item = Item.create!(merchant_id: @merchant.id, name: 'Old Name', description: 'It is an item', unit_price: 5.0)

    item_params = { name: "New Name" }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    patch "/api/v1/items/#{new_item.id}", headers: headers, params: JSON.generate({item: item_params})
    new_item.reload
    expect(response).to be_successful
    expect(new_item.name).to_not eq('Old Name')
    expect(new_item.name).to eq("New Name")
  end

  it 'can delete an item' do
    new_item = Item.create!(merchant_id: @merchant.id, name: 'Old Name', description: 'It is an item', unit_price: 5.0)

    delete "/api/v1/items/#{new_item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(6)
    expect{Item.find(new_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end