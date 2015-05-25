class TemporaryStorage
  def store(file)
    "#{tmp_dir}/#{file.original_filename.parameterize}".tap do |new_path|
      Rails.logger.info("Copying... #{file.path} to #{new_path}")
      FileUtils.mv(file.path, new_path)
    end
  end

  private

  def tmp_dir
    Rails.root.join("tmp/uploads/#{SecureRandom.uuid}").tap do |directory|
      system "mkdir -p #{directory}"
    end
  end
end
