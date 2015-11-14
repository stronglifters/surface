class EmailProcessor
  attr_reader :email

  def initialize(email)
    @email = email
  end

  def process
    user = User.find_by!(email: email.from[:email])

    email.attachments.each do |attachment|
      BackupFile.new(user, attachment).process_later(Program.stronglifts)
    end
  end
end
