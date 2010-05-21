# require 'eycap/recipes'
require 'railsmachine/recipes'

set :application,           "APP_NAME"
set :repository,            "git@github.com:eastmedia/REPOS_URL.git"
set :rails_env,             "production"

# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid]    = false
default_run_options[:pty] = true

# This will execute the Git revision parsing on the *remote* server rather than locally
set :real_revision, lambda { source.query_revision(revision) { |cmd| capture(cmd) } }

load "config/deploy/environments"
load "config/deploy/hooks"
load "config/deploy/tasks"