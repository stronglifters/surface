class UserMailer < ApplicationMailer
  def registration_email(user)
    @username = user.username
    mail to: user.email, subject: "Welcome to Supply."
  end
end
