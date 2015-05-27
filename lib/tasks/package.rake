namespace :package do
  desc "create a build package"
  task build: :environment do
    require "rake/packagetask"

    Rake::PackageTask.new("stronglifters", :noversion) do |p|
      p.need_tar_gz = true
      p.package_files.add %w(
      app/**/*
      config/**/*
      db/**/*
      lib/**/*
      public/**/*
      bin/**/*
      Gemfile
      Gemfile.lock
      README.md
      Rakefile
      Procfile
      config.ru
      )
      p.package_files.exclude do |path|
        path.start_with?("app/assets/") ||
          path.start_with?("config/deploy")
      end
    end
    Rake::Task["package"].invoke
  end
end
