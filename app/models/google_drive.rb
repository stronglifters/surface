class GoogleDrive
  attr_reader :user

  def initialize(user, referrer_domain: ENV["GOOGLE_REFERRER_DOMAIN"])
    @user = user
    @referrer_domain = referrer_domain
  end

  def download(params)
    Dir.mktmpdir do |dir|
      download_path = File.join(dir, params[:data][:title])
      url = params[:data][:downloadUrl].strip
      access_token = params[:accessToken]
      yield BackupFile.new(user, curl(url, download_path, access_token))
    end
  end

  private

  def curl(download_url, download_path, access_token)
    curl = Shell.new("curl")
    curl << "'#{download_url}'"
    curl << "-o '#{download_path}'"
    curl << "-H 'Authorization: Bearer #{access_token}'"
    curl << "-H 'Referer: #{@referrer_domain}/dashboard'"
    curl << "-H 'Origin: #{@referrer_domain}'"
    curl << "--compressed"
    curl.run
    File.new(download_path)
  end
end
