class UploadStrongliftsBackupJob < ActiveJob::Base
  queue_as :default

  def perform(user, backup_file, program)
    tmp_dir do |dir|
      if extract!(backup_file, dir)
        importer_for(dir, user, program).import_from(dir)
      end
    end
  end

  private

  def tmp_dir
    Dir.mktmpdir do |dir|
      yield dir
    end
  end

  def importer_for(directory, user, program)
    [
      Android::Import.new(user, program),
      Ios::Import.new(user, program),
      UnknownFile.new
    ].detect { |x| x.can_parse?(directory) }
  end

  def extract!(backup_file, dir)
    # `unzip #{backup_file} -d #{dir}`
    Zip::File.open(backup_file) do |zip_file|
      zip_file.each do |entry|
        entry.extract(File.join(dir, entry.name))
      end
    end
    true
  rescue StandardError => error
    Rails.logger.error("#{error.message} #{error.backtrace.join(' ')}")
    false
  end

  class UnknownFile
    def can_parse?(_directory)
      true
    end

    def import_from(_directory)
    end
  end
end
