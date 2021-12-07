require 'rails_helper'

describe 'Items API' do
  it 'sends a list of all items' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    create_list(:item, 3, merchant: merchant_1)
    create_list(:item, 3, merchant: merchant_2)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items.count).to eq 6

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(Integer)
      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)
      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)
      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)
      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_a(Integer)
    end
  end

  it "can get one item by its id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)[:item]

    expect(response).to be_successful

    expect(item).to have_key(:id)
    expect(item[:id]).to eq(id)
    expect(item[:id]).to be_an(Integer)
    expect(item).to have_key(:name)
    expect(item[:name]).to be_a(String)
    expect(item).to have_key(:description)
    expect(item[:description]).to be_a(String)
    expect(item).to have_key(:unit_price)
    expect(item[:unit_price]).to be_a(Float)
    expect(item).to have_key(:merchant_id)
    expect(item[:merchant_id]).to be_a(Integer)
  end

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

    it "can destroy an item" do
      item = create(:item)

      expect{ delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)

      expect(response).to be_successful
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'can get the merchant data for an item id' do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_2)

      get "/api/v1/items/#{item_1.id}"

      merchant_info = JSON.parse(response.body, symbolize_names: true)[:merchant]

      expect(merchant_info).to have_key(:id)
      expect(merchant_info[:id]).to eq(merchant_1.id)
      expect(merchant_info).to have_key(:name)
      expect(merchant_info[:name]).to eq(merchant_1.name)

      get "/api/v1/items/#{item_2.id}"

      merchant_info = JSON.parse(response.body, symbolize_names: true)[:merchant]

      expect(merchant_info).to have_key(:id)
      expect(merchant_info[:id]).to eq(merchant_2.id)
      expect(merchant_info).to have_key(:name)
      expect(merchant_info[:name]).to eq(merchant_2.name)
    end
  end