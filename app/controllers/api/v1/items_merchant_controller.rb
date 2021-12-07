class Api::V1::ItemsMerchantController < ApplicationController
  def show
    merchant = Merchant.find((Item.find(params[:id])).merchant_id)
    render json: MerchantSerializer.new(merchant)
  end

end
