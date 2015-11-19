# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'sinatra-server'
set :repo_url, 'git@github.com:plurryinc/sinatra-server.git'

set :rvm_type, :user
set :rvm_ruby_version, '2.2.1'
set :rvm_roles, [:app, :web]

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/ec2-user/sinatra-server'

set :ssh_options, {:forward_agent => true}

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
#set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'db/production.sqlite3')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
set :default_env, { PATH: "/usr/local/rvm/gems/ruby-2.2.1/bin:/usr/local/rvm/rubies/ruby-2.2.1/bin:$PATH",
                    GEM_PATH: "/usr/local/rvm/gems/ruby-2.2.1",
                    GEM_HOME: "/usr/local/rvm/gems/ruby-2.2.1",
                    BUNDLE_PATH: "/usr/local/rvm/gems/ruby-2.2.1"}

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  task :start do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :bundle, 'exec thin start -C config/thin/staging.yml'
      end
    end
  end

  task :stop do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :bundle, 'exec thin stop -C config/thin/staging.yml'
      end
    end
  end
  task :restart do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :bundle, 'exec thin restart -C config/thin/staging.yml'
      end
    end
  end
  task :db_migrate do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, 'db:migrate RACK_ENV=production'
      end
    end
  end

  task :db_seed do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, 'db:seed RACK_ENV=production'
      end
    end
  end

  task :db_setup do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, 'db:migrate RACK_ENV=production'
        execute :rake, 'db:seed RACK_ENV=production'
      end
    end
  end

  task :db_drop do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, 'db:drop RACK_ENV=production'
      end
    end
  end
end

#after "deploy", "deploy:db_migrate"
#after "deploy:db_migrate", "deploy:restart"
