# Change these
server '138.68.139.152', port: 22, roles: [:web, :app, :db], primary: true

set :repo_url,        'git@github.com:chn-challenger/one_maths.git'
set :application,     'one_maths'
set :user,            'deploy'
set :puma_threads,    [4, 16]
set :puma_workers,    0

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log,  "#{release_path}/log/puma.error.log"
set :backup_path,     "/home/#{fetch(:user)}/Backup"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord
# set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
# set :whenever_command, "bundle exec whenever"
## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
# set :linked_files, %w{config/database.yml}
# set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

# namespace :backup do
#
#   desc "Upload backup config files."
#   task :upload_config do
#     on roles(:app) do
#       execute "mkdir -p #{fetch(:backup_path)}/models"
#       upload! StringIO.new(File.read("config/backup/config.rb")), "#{fetch(:backup_path)}/config.rb"
#       upload! StringIO.new(File.read("config/backup/models/db_backup.rb")), "#{fetch(:backup_path)}/models/db_backup.rb"
#     end
#   end
#
#   desc "Upload cron schedule files."
#   task :upload_cron do
#     on roles(:app) do
#       execute "mkdir -p #{fetch(:backup_path)}/config"
#       execute "touch #{fetch(:backup_path)}/config/cron.log"
#       upload! StringIO.new(File.read("config/backup/schedule.rb")), "#{fetch(:backup_path)}/config/schedule.rb"
#
#       within "#{fetch(:backup_path)}" do
#         with path: "/home/#{fetch(:deploy_user)}/.rbenv/shims:$PATH" do
#           puts capture :whenever
#           puts capture :whenever, '--update-crontab'
#         end
#       end
#     end
#   end
#
# end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Backup'
  task :backup do
    on roles(:app) do
      execute "mkdir -p #{fetch(:backup_path)}/models"
      upload! StringIO.new(File.read("config/backup/config.rb")), "#{fetch(:backup_path)}/config.rb"
      upload! StringIO.new(File.read("config/backup/models/db_backup.rb")), "#{fetch(:backup_path)}/models/db_backup.rb"

      execute "mkdir -p #{fetch(:backup_path)}/config"
      execute "touch #{fetch(:backup_path)}/config/cron.log"
      upload! StringIO.new(File.read("config/backup/schedule.rb")), "#{fetch(:backup_path)}/config/schedule.rb"

      # within "#{fetch(:backup_path)}" do
      #   execute :whenever, '--update-crontab'
      # end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma
