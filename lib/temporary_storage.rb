class TemporaryStorage
  def store(file)
    "#{tmp_dir}/#{file.original_filename}".tap do |new_path|
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
