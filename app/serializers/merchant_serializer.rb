class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  # def self.one_merchant(merchant)
  #   a = (
  #   {
  #     "data":
  #       {
  #         "id": "test",
  #         "type": "merchant",
  #         "attributes": {"name": "test"}
  #       }
  #   }
  # )
  # require "pry"; binding.pry
  # end
end
