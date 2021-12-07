class Api::V1::MerchantItemsController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    render json: MerchantItemsSerializer.new(merchant)
  end
end
