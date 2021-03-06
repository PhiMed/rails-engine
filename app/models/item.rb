class Item < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  enum status: { "Disabled" => 0, "Enabled" => 1}

  scope :enabled, -> { where(status: 1) }
  scope :disabled, -> { where(status: 0) }
  
end
