class Api::V1::MerchantItemsController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    render json: merchant.items
  end

  # def show
  #   merchant = Merchant.find(params[:merchant_id])
  #   item = merchant.items.where(id: params[:id])
  #   render json: item
  # end
end
