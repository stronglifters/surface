load File.expand_path("../../tasks/s3.rake", __FILE__)

require "capistrano/scm"

class Capistrano::S3 < Capistrano::SCM
  def s3(*args)
    args.unshift "--profile default"
    args.unshift :s3
    args.unshift :aws
    context.execute(*args)
  end

  module DefaultStrategy
    def test
      test! " [ -f #{repo_path}/HEAD ] "
    end

    def check
      s3 "ls #{bucket_name}"
    end

    def clone
      context.execute("mkdir -p #{repo_path}")
    end

    def update
      source = "s3://#{bucket_name}/#{rails_env}/#{build_revision}"
      destination = "#{repo_path}/#{build_revision}"
      s3 "cp #{source} #{destination}"
    end

    def release
      context.execute("mkdir -p #{release_path}")
      path = "#{repo_path}/#{build_revision}"
      strip = "--strip-components=1"
      context.execute("tar -xvzf #{path} #{strip} -C #{release_path}")
    end

    def bucket_name
      fetch(:bucket_name)
    end

    def rails_env
      fetch(:rails_env)
    end

    def build_revision
      command = [
        "s3 ls #{bucket_name}/#{rails_env}/",
        "grep tar.gz",
        "sort",
        "tail -n1",
        "awk '{ print $4 }'"
      ]
      context.capture(:aws, command.join(" | ")).strip
    end
  end
end
