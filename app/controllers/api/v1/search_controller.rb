class Api::V1::SearchController < ApplicationController

  def item_find
    if params[:min_price].present? && params[:max_price].present? && params[:min_price].present? != true
      item = Item.where("unit_price >= ?", params[:min_price].to_f)
                 .where("unit_price <= ?", params[:max_price].to_f)
                 .order(:name)
      render json: ItemSerializer.new(item)
    elsif
      params[:min_price].present? && params[:min_price].present? != true
      item = Item.where("unit_price >= ?", params[:min_price].to_f)
                 .order(:name)
      render json: ItemSerializer.new(item)
    elsif
      params[:max_price].present? && params[:min_price].present? != true
      item = Item.where("unit_price <= ?", params[:max_price].to_f)
                 .order(:name)
      render json: ItemSerializer.new(item)
    elsif
      params[:name].present?
      item = Item.where("lower(name) like ?", "%#{params[:name].downcase}%")
                 .order(:name)
                 .limit(1)
      render json: ItemSerializer.new(item)
    else
      render json: "error"
    end
  end

  def item_find_all
    item = Item.where("lower(name) like ?", "%#{params[:name].downcase}%")

    render json: ItemSerializer.new(item)
  end

  def merchant_find
     merchant = Merchant.where("lower(name) like ?", "%#{params[:name].downcase}%")
                        .order(:name)
                        .limit(1)
     render json: MerchantSerializer.new(merchant)
  end

  def merchant_find_all
     merchant = Merchant.where("lower(name) like ?", "%#{params[:name].downcase}%")
     render json: MerchantSerializer.new(merchant)
  end
end
