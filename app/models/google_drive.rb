class GoogleDrive
  attr_reader :user

  def initialize(user, referrer_domain: ENV['GOOGLE_REFERRER_DOMAIN'])
    @user = user
    @referrer_domain = referrer_domain
  end

  def download(params)
    Dir.mktmpdir do |dir|
      download_path = File.join(dir, params[:data][:title])
      execute(create_command(
        params[:data][:downloadUrl].strip,
        download_path,
        params[:accessToken]
      ))
      return BackupFile.new(user, File.new(download_path))
    end
  end

  private

  def create_command(download_url, download_path, access_token)
    command = <<-COMMAND
curl '#{download_url}' \
-o '#{download_path}' \
-H 'Authorization: Bearer #{access_token}' \
-H 'Referer: #{@referrer_domain}/dashboard' \
-H 'Origin: #{@referrer_domain}' \
-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.81 Safari/537.36' \
--compressed
    COMMAND
    command
  end

  def execute(command)
    `#{command}`
  end
end
