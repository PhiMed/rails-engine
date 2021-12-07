class MerchantItemsSerializer
  include JSONAPI::Serializer
  has_many :items

  attribute :items
end
