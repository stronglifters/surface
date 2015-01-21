class UserMailerPreview < ActionMailer::Preview
  def registration_email
    UserMailer.registration_email(User.last)
  end
end
