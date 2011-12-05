# Application Settings
set :deploy_to, "/var/www/cornichon"

# Connection Settings
set :host, 'marvin.mll.gvsu.edu'
ssh_options[:username] = 'admin'
default_run_options[:pty] = true

# Source Code Management
set :scm, :git
set :repository,  '.'
set :git_shallow_clone, 1

# Copy Strategy Config
set :deploy_via, :copy
set :copy_strategy, :export
set :copy_compression, :bzip2

# Roles
role :app, host
role :web, host
role :db,  host, :primary => true

after 'deploy:setup' do
  run "mkdir -p #{shared_path}/config"
  sudo "chown -R www:www #{deploy_to}"
end

after 'deploy:update_code', :roles => :app do
  sudo "chown -R www:www #{current_release}"
  sudo "chmod -R g+rwx #{current_release}"
end

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end