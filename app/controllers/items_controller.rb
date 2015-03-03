class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @items = current_user.items
    @item = Item.new
  end

  def show
    @item = current_user.items.find(params[:id])
  end

  def new
    @item = params[:item].present? ? Item.new(secure_params) : Item.new
  end

  def edit
    @item = current_user.items.find(params[:id])
  end

  def create
    current_user.items.create!(secure_params)
    redirect_to dashboard_path
  end

  def update
    item = current_user.items.find(params[:id])
    item.update!(secure_params)
    redirect_to dashboard_path
  end

  def destroy
    current_user.items.destroy(params[:id])
    redirect_to dashboard_path
  end

  private

  def record_not_found
    render text: "404 Not Found", status: 404
  end

  def secure_params
    params.require(:item).permit(
      :name,
      :description,
      :serial_number,
      :purchase_price,
      :purchased_at,
    )
  end
end
