class Api::V1::SearchController < ApplicationController
  def show
    if params[:item_search].present?
      item = Item.where("lower(name) like ?", "%#{params[:item_search].downcase}%").limit(1)
      render json: item
    elsif
      params[:merchant_search].present?
        merchant = Merchant.where("lower(name) like ?", "%#{params[:merchant_search].downcase}%")
        render json: merchant
    end
  end
end
