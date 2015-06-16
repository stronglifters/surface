class GoogleDrive
  attr_reader :user

  def initialize(user, referrer_domain: ENV['GOOGLE_REFERRER_DOMAIN'])
    @user = user
    @referrer_domain = referrer_domain
  end

  def download(params)
    Dir.mktmpdir do |dir|
      download_path = File.join(dir, params[:data][:title])
      download_url = params[:data][:downloadUrl].strip
      access_token = params[:accessToken]
      curl = Shell.new('curl')
      curl << "'#{download_url}'"
      curl << "-o '#{download_path}'"
      curl << "-H 'Authorization: Bearer #{access_token}'"
      curl << "-H 'Referer: #{@referrer_domain}/dashboard'"
      curl << "-H 'Origin: #{@referrer_domain}'"
      curl << "--compressed"
      curl.run
      yield BackupFile.new(user, File.new(download_path))
    end
  end
end
