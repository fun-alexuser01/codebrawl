$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
require 'bundler/capistrano'
require 'capistrano/ext/multistage'

set :application, "codebrawl"
set :repository,  "git@github.com:codebrawl/codebrawl.git"

set :scm, :git
set :ssh_options, { :forward_agent => true }

role :web, "204.62.15.57"
role :app, "204.62.15.57"
set :use_sudo, false
set :rvm_ruby_string, 'ruby-1.9.2'

default_run_options[:pty] = true

before 'deploy:symlink', 'deploy:assets'
after 'deploy:update_code', 'deploy:symlink_settings'
after 'deploy:update_code', 'deploy:symlink_blog'

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc 'Restart Application'
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Compile asets"
  task :assets do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end

  desc 'Symlink the settings file'
  task :symlink_settings, :roles => :app do
    run "ln -s #{shared_path}/codebrawl.yml #{current_release}/config/codebrawl.yml"
  end

end

task :status do
  run("cd #{current_release}; bundle exec rake codebrawl:status RAILS_ENV=#{rails_env}")
end
