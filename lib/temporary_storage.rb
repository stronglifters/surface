class TemporaryStorage
  def store(file)
    "#{tmp_dir}/#{File.basename(file.path).parameterize}".tap do |new_path|
      Rails.logger.debug("Copying... #{file.path} to #{new_path}")
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
