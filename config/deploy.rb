set :application, "ucanhelp"
set :repository,  "git@github.com:VigneshRE/ucanhelp.git"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :deploy_to, "/home/action/apps"
set :user, "action"
set :port, 12472
set :use_sudo, false

role :web, "apse1.actionbox.io"                          # Your HTTP server, Apache/etc
role :app, "apse1.actionbox.io"                          # This may be the same as your `Web` server
role :db,  "apse1.actionbox.io", :primary => true # This is where Rails migrations will run
role :db,  "apse1.actionbox.io"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

load 'deploy/assets'
# require "rvm/capistrano"
# require "bundler/capistrano"
