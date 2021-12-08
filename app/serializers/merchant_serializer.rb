class MerchantSerializer
  include JSONAPI::Serializer
  set_type :merchant
  attributes :name #, :all_items
  # has_many :items
  # def self.format_merchant(merchants)
  #   { "type": "merchant",
  #   "properties": {
  #     "data": { merchants.map do |merchant|
  #       "type": "merchant",
  #       "properties": {
  #         "id": { merchant.id.to_s },
  #         "type": { "merchant" },
  #         "attributes": { 
  #             "properties": {
  #                 "name": { merchant.name },
  #             },
  #             "required": ["name"]
  #           }
  #         },
  #         "required": ["id", "type", "attributes"]
  #         end
  #         }
  #      },
  #       "required": ['data']
  #     }
  # end
end
