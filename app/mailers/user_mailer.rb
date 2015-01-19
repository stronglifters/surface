class UserMailer < ApplicationMailer
  def registration_email(user)
    @name = user.name
    @username = user.username
    mail to: user.email, subject: "Welcome to Supply."
  end
end
