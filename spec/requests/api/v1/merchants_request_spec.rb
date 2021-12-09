require 'rails_helper'

describe 'Merchants API' do

  #index

  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = (JSON.parse(response.body, symbolize_names: true))[:data]

    expect(merchants.count).to eq 3

    merchants.each do |merchant|
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_an(String)
    end
  end

  it 'still returns an array if no merchants exist' do
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = (JSON.parse(response.body, symbolize_names: true))[:data]

    expect(merchants).to be_an(Array)
  end

  #show

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = (JSON.parse(response.body, symbolize_names: true))[:data]

    expect(response).to be_successful

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end

  it 'sad path if merchant doesnt exist' do
    merchant = create(:merchant)

    bad_id = merchant.id + 1

    get "/api/v1/merchants/#{bad_id}"

    parsed_response = (JSON.parse(response.body, symbolize_names: true))

    expect(response.status).to eq(404)

    expect(parsed_response[:errors][:details]).to eq("Not Found")
  end

  #merchant_items index

  it "can get all a merchants items" do
    merchant = create(:merchant)
    create_list(:item, 6, merchant: merchant)
    id = merchant.id

    get "/api/v1/merchants/#{id}/items"

    items = (JSON.parse(response.body, symbolize_names: true))[:data]

    expect(response).to be_successful
    expect(items.count).to eq 6
    expect(items.first).to be_a Hash
    expect(items.first[:attributes].keys).to eq(
      [:name, :description, :unit_price, :merchant_id]
                                   )
  end
end
