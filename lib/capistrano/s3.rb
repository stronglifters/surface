load File.expand_path("../../tasks/s3.rake", __FILE__)

require 'capistrano/scm'

class Capistrano::S3 < Capistrano::SCM
  def s3(*args)
    puts args.inspect
    args.unshift '--profile default'
    args.unshift :s3
    args.unshift :aws
    context.execute *args
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
      s3 "cp s3://#{bucket_name}/#{rails_env}/#{build_revision} #{repo_path}/#{build_revision}"
    end

    def release
      context.execute("mkdir -p #{release_path}")
      context.execute("tar -xvzf #{repo_path}/#{build_revision} --strip-components=1 -C #{release_path}")
    end

    def bucket_name
      fetch(:bucket_name)
    end

    def rails_env
      fetch(:rails_env)
    end

    def build_revision
      "stronglifters-2015-05-29-03-07-33.tar.gz"
    end
  end
end
