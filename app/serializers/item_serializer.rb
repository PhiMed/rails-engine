class ItemSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :description, :unit_price
end
