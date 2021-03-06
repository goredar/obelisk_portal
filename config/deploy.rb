# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'obelisk_portal'
set :repo_url, 'https://github.com/goredar/obelisk_portal.git'
set :rvm_type, :system

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/srv/obelisk_portal'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []) << 'config/database.yml' << 'config/ad.yml' << 'config/secrets.yml' << 'config/asterisk.yml'

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/images/contacts')

# Default value for default_env is {}
# set :default_env, { path: "/usr/local/rvm/gems/ruby-2.1.3/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  after :deploy, :clear_cache do
    on roles(:web) do
      sudo "service nginx restart"
    end
  end
end
