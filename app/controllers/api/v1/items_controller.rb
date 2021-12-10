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
    if params[:name]
      render json: ItemSerializer.new(Item.find_by_name(params[:name]))
    elsif params[:max_price]
      render json: ItemSerializer.new(Item.find_by_max_price(params[:max_price]))
    elsif params[:min_price]
      render json: ItemSerializer.new(Item.find_by_min_price(params[:min_price]))
    end
  end

  def find_all
    if params[:name]
      if Item.where('name ILIKE ?', "%#{params[:name]}%")
        render json: ItemSerializer.new(Item.where('name ILIKE ?', "%#{params[:name]}%"))
      else
        render json: {data: []}, status: 400
      end
    elsif params[:max_price]
      if params[:max_price].to_i < 0
        render json: { error: "This is an error", status: 400 }, status: 400
      end
      if Item.where("unit_price <= #{params[:max_price]}")
        render json: ItemSerializer.new(Item.where("unit_price <= #{params[:max_price]}"))
      else
        render json: {data: []}, status: 400
      end
    elsif params[:min_price]
      if params[:min_price].to_i < 0
        render json: { error: "This is an error", status: 400 }, status: 400
      end
      if Item.where("unit_price >= #{params[:min_price]}")
        render json: ItemSerializer.new(Item.where("unit_price >= #{params[:min_price]}"))
      else
        render json: {data: []}, status: 400
      end
    end
  end

  private

  def item_params
    params.require(:item).permit(:merchant_id, :name, :description, :unit_price)
  end
end