# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'passenger-test-app'
set :repo_url, 'https://github.com/rhenning/passenger-test-app.git'

# Default branch is :master
set :branch, `git rev-parse --abbrev-ref wl-gems`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/weblinc_direct'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/mongoid.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rbenv_type, :system
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_path, '/opt/rbenv'

set :passenger_restart_with_touch, true


namespace :deploy do

  task :whoami do
    on roles(:web) do
      execute :id
    end
  end

  before :restart, :create_date do
    on roles(:web) do
      execute "date > #{current_path}/public/date.txt"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end