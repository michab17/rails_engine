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

  private

  def item_params
    params.require(:item).permit(:merchant_id, :name, :description, :unit_price)
  end
end