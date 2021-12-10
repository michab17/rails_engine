class Item < ApplicationRecord
  belongs_to :merchant

  # def merchant_info
  #   merchant
  # end

  def self.find_by_name(name)
    if name != nil
      Item.where('name ILIKE ?', "%#{name}%").first
    end
  end

  def self.find_by_max_price(price)
    if price != nil
      Item.where("unit_price <= #{price}").first
    end
  end

  def self.find_by_min_price(price)
    if price != nil
      Item.where("unit_price >= #{price}").first
    end
  end

  def self.find_all_by_name(name)
    if name != nil
      Item.where('name ILIKE ?', "%#{name}%")
    end
  end

  def self.find_all_by_max_price(price)
    if price != nil
      Item.where("unit_price <= #{price}")
    end
  end

  def self.find_all_by_min_price(price)
    if price != nil
      Item.where("unit_price >= #{price}")
    end
  end
end