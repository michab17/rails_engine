class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def find
    if params[:name]
      if Merchant.where('name ILIKE ?', "%#{params[:name]}%")
        render json: MerchantSerializer.new(Merchant.where('name ILIKE ?', "%#{params[:name]}%").first)
      else
        render json: {data: {}}
      end
    end
  end

  def find_all
    if params[:name]
      if Merchant.where('name ILIKE ?', "%#{params[:name]}%").first
        render json: MerchantSerializer.new(Merchant.where('name ILIKE ?', "%#{params[:name]}%"))
      else
        render json: {data: []}
      end
    end
  end
end