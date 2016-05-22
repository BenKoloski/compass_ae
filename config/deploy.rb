# config valid only for Capistrano 3.1
lock '3.2.1'

set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.1.5@compass_ae'
set :delayed_job_bin_path, 'script'

set :application, 'benkoloski'
set :repo_url, "/home/compass_ae/repo/compass_ae.git"

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{.rvmrc}

# Default value for linked_dirs is []
set :linked_dirs, %w{tmp/pids public/dba_organizations public/assets public/module_templates log public/compass_ae_reports public/sites public/images/erp_app file_assets}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  task :bundle_install do
    on roles(:app) do
      within release_path do
        execute :bundle, "--gemfile Gemfile --path #{shared_path}/bundle --binstubs #{shared_path}bin --without [:test, :development]"
      end
    end
  end
  after 'deploy:updating', 'deploy:bundle_install'

  namespace :rvm do
    desc 'Trust rvmrc file'
    task :trust_rvmrc do
      on roles(:app) do
        within release_path do
          execute :rvm, "rvmrc trust"
        end
      end
    end
  end
  after "deploy:bundle_install", "rvm:trust_rvmrc"

  desc 'Run data migrations'
  task :data_migrations do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:migrate_data"
        end
      end
    end
  end
  after :migrate, :data_migrations

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  after :publishing, :restart

end
