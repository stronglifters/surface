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
      s3 'ls stronglifters'
    end

    def clone
      context.execute("mkdir -p #{repo_path}")
    end

    def update
      build = "stronglifters-2015-05-29-03-07-33.tar.gz"
      s3 "cp s3://stronglifters/production/#{build} #{repo_path}/#{build}"
    end

    def release
      build = "stronglifters-2015-05-29-03-07-33.tar.gz"
      context.execute("mkdir -p #{release_path}")
      context.execute("tar -xvzf #{repo_path}/#{build} --strip-components=1 -C #{release_path}")
    end
  end
end
