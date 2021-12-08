class Merchant < ApplicationRecord
  has_many :items

  # def all_items
  #   items
  # end
end