set :use_sudo, false
set :application, "twittermancy"
set :repository,  "ssh://code@fury.xybur.net/~/private/#{application}.git"
set :deploy_to, "/home/john/deploy/#{application}"
set :user, 'john'
set :runner, user
set :scm, :git
set :branch, "master"
set :domain, 'fury.xybur.net'
role :app, domain
role :web, domain
role :db,  domain, :primary => true
set :server_name, "twittermancy.urbanpaganism.info"
depend :remote, :command, :gem

# Allow ssh to use ssh keys
set :ssh_options, { :forward_agent => true }

deploy.task :restart do
  # Restart Passenger
  run "touch #{current_path}/tmp/restart.txt"
end

after :deploy, 'deploy:cleanup'
