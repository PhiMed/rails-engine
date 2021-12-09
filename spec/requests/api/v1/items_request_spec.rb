require 'rails_helper'

describe 'Items API' do

  #index

  it 'sends a list of all items' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    create_list(:item, 3, merchant: merchant_1)
    create_list(:item, 3, merchant: merchant_2)

    get '/api/v1/items'

    expect(response).to be_successful

    items = (JSON.parse(response.body, symbolize_names: true))[:data]
    expect(items.count).to eq 6

    items.each do |item|
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end

  it 'still returns an array if no items exist' do
    get '/api/v1/items'

    expect(response).to be_successful

    items = (JSON.parse(response.body, symbolize_names: true))[:data]

    expect(items).to be_an(Array)
  end

  #show

  it "can get one item by its id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = (JSON.parse(response.body, symbolize_names: true))[:data]

    expect(response).to be_successful

    expect(item[:attributes][:name]).to be_a(String)
    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_a(String)
    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to be_a(Float)
  end

  it 'sad path if item doesnt exist' do
    item = create(:item)

    bad_id = item.id + 1

    get "/api/v1/items/#{bad_id}"

    parsed_response = (JSON.parse(response.body, symbolize_names: true))

    expect(response.status).to eq(404)
    expect(parsed_response[:errors][:details]).to eq("Not Found")
  end

#create

  it "can create a new item" do
    merchant_1 = create(:merchant)
    item_params = ({
                    name: 'Shiny New Thing',
                    description: '25mmx25mm shiny thing',
                    unit_price: '1000',
                    merchant_id: merchant_1.id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
  end

  it 'ignores disallowed attribute during creation' do
    merchant_1 = create(:merchant)
    item_params = ({
                    name: 'Shiny New Thing',
                    description: '25mmx25mm shiny thing',
                    unit_price: '1000',
                    merchant_id: merchant_1.id,
                    hectares_per_liter: 50
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.attributes.keys).to eq(
      ["id", "name", "description", "unit_price",
       "merchant_id", "created_at", "updated_at"]
                                               )
  end

  it 'returns an error if an attribute is missing' do
    merchant_1 = create(:merchant)
    item_params = ({
                    name: 'I want to be a triangle',
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    response_data =  JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 400
    expect(response_data[:errors][:details]).to eq("There was an error completing this request")
  end

  #update

  it "can update an existing item" do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: "Even Shinier This Time" }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Even Shinier This Time")
  end

  #destroy

  it "can destroy an item" do
    item = create(:item)

    expect{ delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  #item_merchant show

  it 'can get the merchant data for an item id' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_2)

    get "/api/v1/items/#{item_1.id}/merchant"

    merchant_info = (JSON.parse(response.body, symbolize_names: true))[:data]

    expect(merchant_info[:attributes]).to have_key(:name)
    expect(merchant_info[:attributes][:name]).to eq(merchant_1.name)

    get "/api/v1/items/#{item_2.id}/merchant"

    merchant_info = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant_info[:attributes]).to have_key(:name)
    expect(merchant_info[:attributes][:name]).to eq(merchant_2.name)
  end
end
