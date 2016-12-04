class JsonWebToken
  def self.encode(payload)
    JWT.encode(payload, secret)
  end

  def self.decode(token)
    decoded = JWT.decode(token, secret)
    decoded.first.with_indifferent_access
  rescue
    nil
  end

  def self.secret
    Rails.application.secrets.secret_key_base
  end
end
