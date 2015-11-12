workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

rails_root = File.expand_path("../..", __FILE__)

environment ENV['RAILS_ENV'] || "production"

bind "unix:#{rails_root}/tmp/sockets/puma.sock"
bind "tcp://127.0.0.1:9292"

# Set master PID and state locations
pidfile "#{rails_root}/tmp/pids/puma.pid"
state_path "#{rails_root}/tmp/pids/puma.state"
activate_control_app

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection
end
