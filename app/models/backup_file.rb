require "temporary_storage"

class BackupFile
  attr_reader :user, :backup_file

  def initialize(user, backup_file)
    @user = user
    @backup_file = backup_file
  end

  def process_later(program)
    UploadStrongliftsBackupJob.perform_later(
      user,
      storage.store(backup_file),
      program
    ) if valid?
  end

  def valid?
    extension = File.extname(backup_file.path)
    extension.start_with?(".stronglifts") ||
      extension.start_with?(".csv")
  end

  private

  def storage
    @storage ||= TemporaryStorage.new
  end
end
