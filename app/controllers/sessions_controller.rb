class SessionsController < ApplicationController
  
  def destroy
    reset_session()
    render :nothing => true
  end
  
end
