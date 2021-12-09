class Api::V1::SearchController < ApplicationController

  def item_find_director
    if params[:name].present?
      self.item_find_name
    elsif
      params[:min_price].present? && params[:max_price].present?
        self.item_find_min_max
    elsif
      params[:min_price].present? && params[:min_price].to_f > 0
        self.item_find_min
    elsif
      params[:max_price].present? && params[:max_price].to_f > 0
        self.item_find_max
    else
      render json: {error: {details: "Search fields cannot be blank"}}, status: 400
    end
  end


  def item_find_name
    if params[:min_price].present? || params[:max_price].present?
      render json: {error: {details: "Search must must either be price or name, not both"}}, status: 400
    else
      item = Item.where("lower(name) like ?", "%#{params[:name].downcase}%")
             .order(:name)
             .first
        if item.nil?
          render json: {data: {message: "No matches"}}
        else
          render json: ItemSerializer.new(item)
        end
    end
  end

  def item_find_min_max
    if params[:min_price].to_f < params[:max_price].to_f && params[:min_price].to_f > 0
      item = Item.where("unit_price >= ?", params[:min_price].to_f)
                 .where("unit_price <= ?", params[:max_price].to_f)
                 .order(:name)
                 .first
      render json: ItemSerializer.new(item)
    else
      render json: {error: {details: "Invalid parameters 26"}}, status: 400
    end
  end

  def item_find_min
    item = Item.where("unit_price >= ?", params[:min_price].to_f)
               .order(:name)
               .first
    if item.nil?
      render json: {data: {message: "No matches"}}
    else
      render json: ItemSerializer.new(item)
    end
  end

  def item_find_max
    item = Item.where("unit_price <= ?", params[:max_price].to_f)
               .order(:name)
               .first
    if item.nil?
      render json: {data: {message: "No matches"}}
    else
      render json: ItemSerializer.new(item)
    end
  end

  def item_find_all
    if params[:name].present?
      item = Item.where("lower(name) like ?", "%#{params[:name].downcase}%")
      render json: ItemSerializer.new(item)
    else
      render json: {error: {details: "Search fields cannot be blank"}}, status: 400
    end
  end

  def merchant_find
    if params[:name].present?
      merchant = Merchant.where("lower(name) like ?", "%#{params[:name].downcase}%")
                          .order(:name)
                          .first
      if merchant.nil?
        render json: {data: {message: "No matches"}}
      else
        render json: MerchantSerializer.new(merchant)
      end
    else
      render json: {error: {details: "Name cannot be blank"}}, status: 400
    end
  end

  def merchant_find_all
    if params[:name].present?
      merchant = Merchant.where("lower(name) like ?", "%#{params[:name].downcase}%")
      render json: MerchantSerializer.new(merchant)
    else
     render json: {error: {details: "Search fields cannot be blank"}}, status: 400
    end
  end
end
