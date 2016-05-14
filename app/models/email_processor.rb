class EmailProcessor
  attr_reader :email

  def initialize(email)
    @email = email
  end

  def process
    tokens = email.to.map { |x| x[:token] }.uniq
    User.find(tokens).each do |user|
      user.add_to_inbox(email)
    end
  end
end
