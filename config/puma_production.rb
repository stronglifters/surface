# Change to match your CPU core count
workers Integer(ENV['WEB_CONCURRENCY'] || 2)

# Min and Max threads per worker
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

rails_root = File.expand_path("../..", __FILE__)

# Default to production
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

# Set up socket location
bind "unix:#{rails_root}/tmp/sockets/puma.sock"

# Logging
stdout_redirect "#{rails_root}/log/puma.stdout.log", "#{rails_root}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{rails_root}/tmp/pids/puma.pid"
state_path "#{rails_root}/tmp/pids/puma.state"
activate_control_app

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("#{rails_root}/config/database.yml")[rails_env])
end
