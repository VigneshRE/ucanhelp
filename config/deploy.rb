set :application, "ucanhelp"
set :repository,  "git@github.com:VigneshRE/ucanhelp.git"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :deploy_to, "/home/ec2-user/apps"
set :user, "ec2-user"
set :port, 22
set :use_sudo, false
ssh_options[:forward_agent] = true
ssh_options[:auth_methods] = ["publickey"]
ssh_options[:keys] = ["/Users/vigneshr/Desktop/ucanhelp.pem"]

role :web, "ec2-54-244-75-143.us-west-2.compute.amazonaws.com"                          # Your HTTP server, Apache/etc
role :app, "ec2-54-244-75-143.us-west-2.compute.amazonaws.com"                          # This may be the same as your `Web` server
role :db,  "ec2-54-244-75-143.us-west-2.compute.amazonaws.com", :primary => true # This is where Rails migrations will run
role :db,  "ec2-54-244-75-143.us-west-2.compute.amazonaws.com"

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

set :default_environment, { "PATH" =>
"$HOME/nodejs/node-v0.10.1-linux-x64/bin:$PATH"
}

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
require 'bundler/capistrano'
set :rvm_ruby_string, 'ruby-1.9.3-p374'
set :rvm_type, :user
load 'deploy/assets'
