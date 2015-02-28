class ItemsController < ApplicationController
  def index
    current_user = User.find(session[:user_id])
    @items = current_user.items
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end
end
