class DownloadFromDriveJob < ActiveJob::Base
  queue_as :default

  def perform(user, params)
    user.google_drive.download(params) do |backup_file|
      backup_file.process_later(Program.stronglifts)
    end
  end
end
