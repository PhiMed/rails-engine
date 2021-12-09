require 'rails_helper'

describe 'Search API' do

  #item_find

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

    get '/api/v1/items/find?name=zzz'

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    expect(parsed_response[:data][:message]).to eq("No matches")
  end

  it 'returns an item by min_price' do
    item_1 = create(:item, unit_price: 1000)
    item_2 = create(:item, unit_price: 100)

    get '/api/v1/items/find?min_price=200'

    expect(response).to be_successful

    searched_item = JSON.parse(response.body, symbolize_names: true)

    expect(searched_item.count).to eq 1
    expect(searched_item[:data][:attributes][:name]).to eq("#{item_1.name}")

    get '/api/v1/items/find?min_price=9999'

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    expect(parsed_response[:data][:message]).to eq("No matches")

  end

  it 'returns items by max_price' do
    item_1 = create(:item, unit_price: 1000)
    item_2 = create(:item, unit_price: 100)

    get '/api/v1/items/find?max_price=200'

    expect(response).to be_successful

    searched_item = JSON.parse(response.body, symbolize_names: true)

    expect(searched_item.count).to eq 1
    expect(searched_item[:data][:attributes][:name]).to eq("#{item_2.name}")

    get '/api/v1/items/find?max_price=1'

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    expect(parsed_response[:data][:message]).to eq("No matches")

  end

  it 'find_item min_price AND max_price' do
    item_1 = create(:item, unit_price: 1000)
    item_2 = create(:item, unit_price: 101)
    item_3 = create(:item, unit_price: 1)

    get '/api/v1/items/find?max_price=200&min_price=50'

    expect(response).to be_successful

    searched_item = JSON.parse(response.body, symbolize_names: true)

    expect(searched_item.count).to eq 1
    expect(searched_item[:data][:attributes][:name]).to eq("#{item_2.name}")

    get '/api/v1/items/find?max_price=100&min_price=200'

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)
    expect(parsed_response[:error][:details]).to eq("Invalid parameters")
  end

  it 'returns an error if name and price search params are both present' do
    create_list(:item, 3)

    get '/api/v1/items/find?max_price=200&name=steve'

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)
    expect(parsed_response[:error][:details]).to eq("Search must must either be price or name, not both")
  end

  it 'returns an error if no search params are present' do
    create_list(:item, 3)

    get '/api/v1/items/find'

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)
    expect(parsed_response[:error][:details]).to eq("Search fields cannot be blank")
  end

  #item_find_all
  it 'returns many searched items (name)' do
    item_1 = create(:item, name: "Stuffed Penguin")
    item_2 = create(:item, name: "Stuffed Walrus")
    item_2 = create(:item, name: "ALibaster Pigeon")

    get '/api/v1/items/find_all?name=stuffed'

    expect(response).to be_successful

    searched_items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(searched_items.count).to eq 2
    expect(searched_items.pluck(:attributes).pluck(:name)).to eq(["Stuffed Penguin", "Stuffed Walrus"])

    get '/api/v1/items/find_all?name'

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)
    expect(parsed_response[:error][:details]).to eq("Search fields cannot be blank")
  end

  #merchant_find
  it 'returns one searched merchant' do
    merchant_1 = create(:merchant, name: 'Arctic Inc')
    merchant_2 = create(:merchant, name: 'Antarctic Inc')
    merchant_3 = create(:merchant, name: 'Hildas Hammocks')

    get '/api/v1/merchants/find?name=inc'

    expect(response).to be_successful

    searched_merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(searched_merchant[:attributes][:name]).to eq("Antarctic Inc")

    get '/api/v1/merchants/find?name=zzz'

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    expect(parsed_response[:data][:message]).to eq("No matches")

    get '/api/v1/merchants/find'

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)
    expect(parsed_response[:error][:details]).to eq("Name cannot be blank")
end

  #merchant_find_all

  it 'returns many searched merchants' do
    merchant_1 = create(:merchant, name: 'Arctic Inc')
    merchant_2 = create(:merchant, name: 'Antarctic Inc')
    merchant_3 = create(:merchant, name: 'Hildas Hammocks')

    get '/api/v1/merchants/find_all?name=inc'

    expect(response).to be_successful

    searched_merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(searched_merchants.count).to eq 2
    expect(searched_merchants).not_to include(merchant_3)

    get '/api/v1/merchants/find_all'

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)
    expect(parsed_response[:error][:details]).to eq("Search fields cannot be blank")
  end
end
