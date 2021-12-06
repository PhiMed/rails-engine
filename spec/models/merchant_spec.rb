require 'rails_helper'
# FactoryBot.find_definitions

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it {should have_many :items}
  end
end
