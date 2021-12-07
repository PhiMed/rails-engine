class Merchant < ApplicationRecord
  has_many :items
  has_many :bulk_discounts
  has_many :invoice_items, through: :items
  enum status: { "Disabled" => 0, "Enabled" => 1}
  scope :enabled, -> { where(status: 1) }
  scope :disabled, -> { where(status: 0) }
end
