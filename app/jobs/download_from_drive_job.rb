class DownloadFromDriveJob < ActiveJob::Base
  queue_as :default

  def perform(params)
    puts params.inspect
    Dir.mktmpdir do |dir|
      download_path = File.join(dir, params[:title])
      `wget -O #{download_path} #{params[:downloadUrl]}`
    end
  end
end
