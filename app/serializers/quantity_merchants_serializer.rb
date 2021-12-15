class QuantityMerchantsSerializer
  include JSONAPI::Serializer
  attributes :name

  attributes :count do |object|
    object.count
  end
end