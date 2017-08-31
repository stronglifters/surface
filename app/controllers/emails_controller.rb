class EmailsController < ApplicationController
  def index
    @emails = paginate(current_user.received_emails.order(created_at: :desc))
  end
end
