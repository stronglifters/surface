class UploadStrongliftsBackupJob < ActiveJob::Base
  WORKOUTS_SQL = "select * from workouts"
  queue_as :default

  def perform(user, backup_file, program)
    tmp_dir do |dir|
      `unzip #{backup_file} -d #{dir}`
      importer = importer_for(dir, user, program)
      database(dir) do |db|
        db.execute(WORKOUTS_SQL) do |row|
          importer.import(row)
        end
      end
    end
  end

  private

  def tmp_dir
    Dir.mktmpdir do |dir|
      yield dir
    end
  end

  def database(dir)
    yield SQLite3::Database.new("#{dir}/stronglifts.db")
  end

  def importer_for(directory, user, program)
    AndroidImport.new(user, program)
  end
end
