require 'rails_helper'

describe 'Search API' do
  it 'returns a single searched item (name)' do
    merchant_1 = create(:merchant, name: 'Arctic Inc')
    merchant_2 = create(:merchant, name: 'Antarctic Inc')
    item_1 = create(:item, merchant: merchant_1, name: "Stuffed Penguin")
    item_2 = create(:item, merchant: merchant_2, name: "Stuffed Walrus")

    get '/api/v1/items/find?name=stuffed'

    expect(response).to be_successful

    searched_item = JSON.parse(response.body, symbolize_names: true)

    expect(searched_item.count).to eq 1
    expect(searched_item[:data][:attributes][:name]).to eq "Stuffed Penguin"
  end

  it 'returns an item by min_price' do
    item_1 = create(:item, unit_price: 1000)
    item_2 = create(:item, unit_price: 100)

    get '/api/v1/items/find?min_price=200'

    expect(response).to be_successful

    searched_item = JSON.parse(response.body, symbolize_names: true)

    expect(searched_item.count).to eq 1
    expect(searched_item[:data][:attributes][:name]).to eq("#{item_1.name}")

  end

  it 'returns items by max_price' do
    item_1 = create(:item, unit_price: 1000)
    item_2 = create(:item, unit_price: 100)

    get '/api/v1/items/find?max_price=200'

    expect(response).to be_successful

    searched_item = JSON.parse(response.body, symbolize_names: true)

    expect(searched_item.count).to eq 1
    expect(searched_item[:data][:attributes][:name]).to eq("#{item_2.name}")
  end

  it 'returns an error if name and price search params are both present' do
    create_list(:item, 3)

    get '/api/v1/items/find?max_price=200&name=steve'

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)
    expect(parsed_response[:error][:details]).to eq("Search must must either be price or name, not both")
  end

  it 'returns many searched merchants' do
    merchant_1 = create(:merchant, name: 'Arctic Inc')
    merchant_2 = create(:merchant, name: 'Antarctic Inc')
    merchant_3 = create(:merchant, name: 'Hildas Hammocks')

    get '/api/v1/merchants/find_all?name=inc'

    expect(response).to be_successful

    searched_merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(searched_merchants.count).to eq 2
    expect(searched_merchants).not_to include(merchant_3)
  end
end
