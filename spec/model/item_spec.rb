require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
  end
  let(:merchant) { Merchant.create!(name: 'Kevin') }
  let!(:item1) { Item.create!(merchant_id: merchant.id, name: 'Pen', description: 'It is an item', unit_price: 5.0) }
  let!(:item2) { Item.create!(merchant_id: merchant.id, name: 'Phone', description: 'It is an item', unit_price: 10.0) }
  let!(:item3) { Item.create!(merchant_id: merchant.id, name: 'Water Bottle', description: 'It is an item', unit_price: 15.0) }

  describe '::find_by_name' do
    it 'finds a single item by its name' do
      expect(Item.find_by_name("Wat")).to eq(item3)
    end
  end

  describe '::find_by_max_price' do
    it 'finds a single item by its name' do
      expect(Item.find_by_max_price("6.0")).to eq(item1)
    end
  end

  describe '::find_by_min_price' do
    it 'finds a single item by its name' do
      expect(Item.find_by_min_price("11.0")).to eq(item3)
    end
  end

  describe '::find_all_by_name' do
    it 'finds all items by their name' do
      expect(Item.find_all_by_name("P")).to eq([item1, item2])
    end
  end

  describe '::find_all_by_max_price' do
    it 'finds all items by their name' do
      expect(Item.find_all_by_max_price("14.0")).to eq([item1, item2])
    end
  end

  describe '::find_all_by_min_price' do
    it 'finds all items by their name' do
      expect(Item.find_all_by_min_price("6.0")).to eq([item2, item3])
    end
  end
end