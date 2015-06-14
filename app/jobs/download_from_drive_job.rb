class DownloadFromDriveJob < ActiveJob::Base
  queue_as :default

  def perform(user, params)
    Dir.mktmpdir do |dir|
      download_path = File.join(dir, params[:data][:title])
      execute(create_command(
        params[:data][:downloadUrl].strip,
        download_path,
        params[:accessToken]
      ))
      UploadStrongliftsBackupJob.perform_later(
        user,
        storage.store(File.new(download_path)),
        Program.stronglifts
      )
    end
  end

  private

  def storage
    @storage ||= TemporaryStorage.new
  end

  def create_command(download_url, download_path, access_token)
    command = <<-COMMAND
curl '#{download_url}' \
-o '#{download_path}' \
-H 'Authorization: Bearer #{access_token}' \
-H 'Referer: http://stronglifters.dev/dashboard' \
-H 'Origin: http://stronglifters.dev' \
-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.81 Safari/537.36' \
--compressed
COMMAND
    command
  end

  def execute(command)
    `#{command}`
  end
end
