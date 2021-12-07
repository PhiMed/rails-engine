require 'rails_helper'

describe 'Search API' do
  it 'returns a single searched item' do
    merchant_1 = create(:merchant, name: 'Arctic Inc')
    merchant_2 = create(:merchant, name: 'Antarctic Inc')
    item_1 = create(:item, merchant: merchant_1, name: "Stuffed Penguin")
    item_2 = create(:item, merchant: merchant_2, name: "Stuffed Walrus")

    get '/api/v1/search?item_search=stuffed'

    expect(response).to be_successful

    searched_item = JSON.parse(response.body, symbolize_names: true)

    expect(searched_item.count).to eq 1
    expect(searched_item.first[:name]).to eq "Stuffed Penguin"
  end

  it 'returns many searched merchants' do
    merchant_1 = create(:merchant, name: 'Arctic Inc')
    merchant_2 = create(:merchant, name: 'Antarctic Inc')
    merchant_3 = create(:merchant, name: 'Hildas Hammocks')

    get '/api/v1/search?merchant_search=inc'

    expect(response).to be_successful

    searched_merchants = JSON.parse(response.body, symbolize_names: true)

    expect(searched_merchants.count).to eq 2
    expect(searched_merchants).not_to include(merchant_3)
  end
end
