#app_name = "animeon"
app_path = ENV['RAILS_ENV'] == 'production' ? "/rails" : "/home/devops/animeon"
shared_path = "#{app_path}/shared"

worker_processes 32
timeout 90
# listen "#{shared_path}/tmp/sockets/unicorn.socket", backlog: 4096
listen ENV['RAILS_ENV'] == 'production' ? 9001 : 5100, :tcp_nopush => true
user ENV['RAILS_ENV'] == 'production' ? 'rails' : 'devops'

working_directory app_path
stdout_path "#{shared_path}/log/unicorn.access.log"
stderr_path "#{shared_path}/log/unicorn.error.log"

pid "#{shared_path}/tmp/pids/unicorn.pid"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

check_client_connection false

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{app_path}/Gemfile"
end

before_fork do |server, worker|
  defined?(ApplicationRecord) and
    ApplicationRecord.connection.disconnect!
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      sig = ((worker.nr + 1) >= server.worker_processes) ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  require 'prometheus_exporter/instrumentation'
  PrometheusExporter::Instrumentation::ActiveRecord.start(
    custom_labels: { type: "unicorn_worker" }, #optional params
    config_labels: [:database, :host] #optional params
  )
  ApplicationRecord.establish_connection
end
