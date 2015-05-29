namespace :s3 do
  def strategy
    @strategy ||= Capistrano::S3.new(self, Capistrano::S3::DefaultStrategy)
  end

  set :s3_environmental_variables, ->() {
    {
      bucket_name: fetch(:s3_bucket),
      build_revision: fetch(:build_revision),
    }
  }

  task :wrapper do
    on release_roles :all do
    end
  end

  desc 'Check that the repository is reachable'
  task check: :'s3:wrapper' do
    fetch(:branch)
    on release_roles :all do
      with fetch(:s3_environmental_variables) do
        strategy.check
      end
    end
  end

  desc 'Clone the repo to the cache'
  task clone: :'s3:wrapper' do
    on release_roles :all do
      if strategy.test
        info t(:mirror_exists, at: repo_path)
      else
        within deploy_path do
          with fetch(:s3_environmental_variables) do
            strategy.clone
          end
        end
      end
    end
  end

  desc 'Update the repo mirror to reflect the origin state'
  task update: :'s3:clone' do
    on release_roles :all do
      within repo_path do
        with fetch(:s3_environmental_variables) do
          strategy.update
        end
      end
    end
  end

  desc 'Copy repo to releases'
  task create_release: :'s3:update' do
    on release_roles :all do
      with fetch(:s3_environmental_variables) do
        within repo_path do
          execute :mkdir, '-p', release_path
          strategy.release
        end
      end
    end
  end

  desc 'Determine the revision that will be deployed'
  task :set_current_revision do
    on release_roles :all do
      within repo_path do
        with fetch(:s3_environmental_variables) do
          set :current_revision, fetch(:build_revision)
        end
      end
    end
  end
end
