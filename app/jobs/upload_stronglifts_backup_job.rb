class UploadStrongliftsBackupJob < ActiveJob::Base
  queue_as :default

  def perform(user, backup_file, program)
    tmp_dir do |dir|
      `unzip #{backup_file} -d #{dir}`
      ActiveRecord::Base.transaction do
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

  class UnknownFile
    def can_parse?(directory)
      true
    end

    def import_from(directory)
    end
  end
end
