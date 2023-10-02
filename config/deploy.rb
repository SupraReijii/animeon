set :application, 'animeon'
set :repo_name, 'animeon'
set :repo_url, "git@github.com:SupraReijii/#{fetch :repo_name}.git"
set :rails_env, fetch(:stage)
set :current_directory, 'current'
set :user, 'devops'
set :group, 'devops'
set :unicorn_user, 'devops'

set :linked_files, %w[
  config/database.yml
  config/secrets.yml
]

set :linked_dirs, %w[
  log
  tmp/pids
  tmp/cache
  tmp/sockets
  public/assets
  public/system
  public/uploads
  public/packs
  public/.well-known/acme-challenge
]
set :copy_files, %w[node_modules]

set :keep_releases, 5
set :log_level, :info
set :format, :airbrussh

set :branch, ENV['BRANCH'] if ENV['BRANCH']

Airbrussh.configure do |config|
  config.truncate = false
end

namespace :deploy do
  namespace :file do
    task :lock do
      on roles(:app) do
        execute "touch /tmp/deploy_#{fetch :application}_#{fetch :stage}.lock"
      end
    end

    task :unlock do
      on roles(:app) do
        execute "rm /tmp/deploy_#{fetch :application}_#{fetch :stage}.lock"
      end
    end
  end

  namespace :yarn do
    task :install do
      on roles(:app) do
        execute "cd #{release_path} && yarn"
      end
    end
  end
end

namespace :unicorn do
  desc "Stop unicorn"
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo systemctl stop #{fetch :application}_unicorn_#{fetch :stage}"
    end
  end

  desc "Start unicorn"
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo systemctl start #{fetch :application}_unicorn_#{fetch :stage}"
    end
  end

  desc "Restart unicorn"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo systemctl reload #{fetch :application}_unicorn_#{fetch :stage} || sudo systemctl restart #{fetch :application}_unicorn_#{fetch :stage}"
    end
  end
end


before 'deploy:assets:precompile', 'deploy:yarn:install'
