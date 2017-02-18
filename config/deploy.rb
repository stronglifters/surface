# config valid only for current version of Capistrano
lock "3.7.2"

set :application, "stronglifters"
set :repo_url, "git@gitlab.com:stronglifters/surface.git"

# Default branch is :master
# ask :branch, `git revparse abbrevref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :ssh_options, forward_agent: true
set :rbenv_type, :system
set :rbenv_ruby, `cat .ruby-version`.strip

namespace :deploy do
  task :restart do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      sudo :sv, "restart puma"
    end
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      sudo :sv, "restart sidekiq"
    end
  end

  after :publishing, :restart
end
