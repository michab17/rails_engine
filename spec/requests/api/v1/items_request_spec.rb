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
    items[:data].each do |item|
      expect(item[:id]).to be_an(String)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end

  it 'gets a one item with its id' do
    get "/api/v1/items/#{@item1.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)
    expect(item[:data][:id]).to be_an(String)
    expect(item[:data][:attributes][:name]).to be_a(String)
    expect(item[:data][:attributes][:description]).to be_a(String)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)
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

    expect(response.status).to eq 201
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
    
    new_item.reload
    delete "/api/v1/items/#{new_item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(6)
    expect{Item.find(new_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can find all items with a search by name' do
    get "/api/v1/items/find_all?name=item"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(items[:data][0][:id]).to eq(@item1.id.to_s)
    expect(items[:data][0][:attributes][:name]).to eq(@item1.name)
    expect(items[:data][0][:attributes][:description]).to eq(@item1.description)
    expect(items[:data].last[:id]).to eq(@item6.id.to_s)
    expect(items[:data].last[:attributes][:name]).to eq(@item6.name)
    expect(items[:data].last[:attributes][:description]).to eq(@item6.description)
  end

  it 'can find all items with a search by max price' do
    get "/api/v1/items/find_all?max_price=11.00"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(items[:data][0][:id]).to eq(@item1.id.to_s)
    expect(items[:data][0][:attributes][:name]).to eq(@item1.name)
    expect(items[:data][0][:attributes][:description]).to eq(@item1.description)
    expect(items[:data].last[:id]).to eq(@item5.id.to_s)
    expect(items[:data].last[:attributes][:name]).to eq(@item5.name)
    expect(items[:data].last[:attributes][:description]).to eq(@item5.description)
  end

  it 'can find all items with a search by min price' do
    get "/api/v1/items/find_all?min_price=6.0"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(items[:data][0][:id]).to eq(@item2.id.to_s)
    expect(items[:data][0][:attributes][:name]).to eq(@item2.name)
    expect(items[:data][0][:attributes][:description]).to eq(@item2.description)
    expect(items[:data].last[:id]).to eq(@item6.id.to_s)
    expect(items[:data].last[:attributes][:name]).to eq(@item6.name)
    expect(items[:data].last[:attributes][:description]).to eq(@item6.description)
  end

  it 'can find one item by name' do
    get "/api/v1/items/find?name=1"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(items[:data][:id]).to eq(@item1.id.to_s)
    expect(items[:data][:attributes][:name]).to eq(@item1.name)
    expect(items[:data][:attributes][:description]).to eq(@item1.description)
  end

  it 'can find one item by max price' do
    get "/api/v1/items/find?max_price=6.0"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(items[:data][:id]).to eq(@item1.id.to_s)
    expect(items[:data][:attributes][:name]).to eq(@item1.name)
    expect(items[:data][:attributes][:description]).to eq(@item1.description)
  end

  it 'can find one item by min price' do
    get "/api/v1/items/find?min_price=6.0"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(items[:data][:id]).to eq(@item2.id.to_s)
    expect(items[:data][:attributes][:name]).to eq(@item2.name)
    expect(items[:data][:attributes][:description]).to eq(@item2.description)
  end

  it 'find: returns an error if the min price is less than zero' do
    get "/api/v1/items/find?min_price=-1.0"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq 400
  end

  it 'find_all: returns an error if the min price is less than zero' do
    get "/api/v1/items/find_all?min_price=-1.0"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq 400
  end

  it 'returns an error if the name has no matches' do
    get "/api/v1/items/find?name=thishasnomatches"

    expect(response).to_not be_successful
    expect(response.status).to eq 400
  end

  it 'returns an error if name and price are sent' do
    get '/api/v1/items/find?name=ring&max_price=50'

    expect(response).to_not be_successful
    expect(response.status).to eq 400
  end

  it 'returns an error min price is so big nothing matchs' do
    get '/api/v1/items/find?min_price=10000.0'

    expect(response).to_not be_successful
    expect(response.status).to eq 400
  end
end