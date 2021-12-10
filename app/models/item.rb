class Item < ApplicationRecord
  belongs_to :merchant

  # def merchant_info
  #   merchant
  # end

  def self.find_by_name(name)
    if Item.where('name ILIKE ?', "%#{name}%").first
      Item.where('name ILIKE ?', "%#{name}%").first
    end
  end

  def self.find_by_max_price(price)
    # if params[:max_price].to_i < 0
    #   render json: { error: "This is an error", status: 400 }, status: 400
    if Item.where("unit_price <= #{price}").first
      Item.where("unit_price <= #{price}").first
    end
  end

  def self.find_by_min_price(price)
    # if params[:min_price].to_i < 0
    #   render json: { error: "This is an error", status: 400 }, status: 400
    if Item.where("unit_price >= #{price}").first
      Item.where("unit_price >= #{price}").first
    end
  end
end