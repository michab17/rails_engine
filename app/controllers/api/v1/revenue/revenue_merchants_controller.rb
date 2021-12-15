class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    if params[:quantity].to_i
      quantity = params[:quantity]
      merchants = Merchant.top_merchants_by_revenue(quantity)
      render json: RevenueMerchantsSerializer.new(merchants)
    end
  end
end