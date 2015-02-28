class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @items = current_user.items
  end

  def show
    @item = current_user.items.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def edit
    @item = current_user.items.find(params[:id])
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def record_not_found
    render text: "404 Not Found", status: 404
  end
end
