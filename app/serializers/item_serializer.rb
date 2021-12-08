class ItemSerializer
  include JSONAPI::Serializer
  attributes :merchant_id, :name, :description, :unit_price #, :merchant_info
  # belongs_to :merchant
end
