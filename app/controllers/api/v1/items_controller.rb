class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    render json: ItemSerializer.new(Item.create(item_params)), status: 201
  end

  def update
    if params[:merchant_id] == nil || Merchant.find(params[:merchant_id])
      render json: ItemSerializer.new(Item.update(params[:id], item_params))
    else
      render json: { errors: { description: 'Merchant not found' } }, status: 404
    end
  end

  def destroy
    item = Item.find(params[:id])
    Item.destroy(params[:id])
    render json: item
  end

  def find
    if params[:min_price].to_i < 0 || params[:max_price].to_i < 0
      render json: { error: "The parameters were entered incorrectly", status: 400 }, status: 400
    elsif Item.where('name ILIKE ?', "%#{params[:name]}%").first && params[:max_price].nil? && params[:min_price].nil?
      render json: ItemSerializer.new(Item.find_by_name(params[:name]))
    elsif Item.find_by_min_price(params[:min_price]) && params[:name].nil? && params[:max_price].nil?
      render json: ItemSerializer.new(Item.find_by_min_price(params[:min_price]))
    elsif Item.find_by_max_price(params[:max_price]) && params[:name].nil? && params[:min_price].nil?
      render json: ItemSerializer.new(Item.find_by_max_price(params[:max_price]))
    else 
      render json: {data: {}}, status: 400
    end
  end

  def find_all
    if params[:max_price].to_i < 0 || params[:min_price].to_i < 0
      render json: { error: "This is an error", status: 400 }, status: 400
    elsif Item.where('name ILIKE ?', "%#{params[:name]}%") && params[:max_price].nil? && params[:min_price].nil?
      render json: ItemSerializer.new(Item.find_all_by_name(params[:name]))
    elsif Item.find_by_min_price(params[:min_price]) && params[:name].nil? && params[:max_price].nil?
      render json: ItemSerializer.new(Item.find_all_by_min_price(params[:min_price]))
    elsif Item.find_by_max_price(params[:max_price]) && params[:name].nil? && params[:min_price].nil?
      render json: ItemSerializer.new(Item.find_all_by_max_price(params[:max_price]))
    else
      render json: {data: {}}, status: 400
    end
  end

  private

  def item_params
    params.require(:item).permit(:merchant_id, :name, :description, :unit_price)
  end
end