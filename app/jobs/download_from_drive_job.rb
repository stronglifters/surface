class DownloadFromDriveJob < ActiveJob::Base
  queue_as :default

  def perform(user, params)
    backup_file = user.google_drive.download(params)
    backup_file.process_later(Program.stronglifts)
  end
end
