
# require 'eycap/recipes'
# require 'config/recipes/railsmachine'
$LOAD_PATH.unshift File.dirname(__FILE__) + "/../vendor/plugins"
require "cap_db_dump/lib/cap_db_dump/recipes"


set :keep_releases, 5

default_run_options[:pty] = true
set :repository,            'git@github.com:eastmedia/REPOS_URL.git'
set :scm,                   'git'
set :deploy_via,            :fast_remote_cache
set :git_shallow_clone,     1
set :git_enable_submodules, false
set :rails_env,             'production'

# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false

# This will execute the Git revision parsing on the *remote* server rather than locally
set :real_revision, lambda { source.query_revision(revision) { |cmd| capture(cmd) } }

set  :application,          "APP_NAME"


desc "Production deploys"
task :production do
  set  :user,                 "deploy"
  set  :password,             "PASSWORD"

  set  :branch,               "master"
  set  :deploy_to,            "/var/www/apps/#{application}"
  set  :deployment,           "production"
  set  :production_domain,    "EXAMPLE.COM"

  set  :domain,               production_domain
  role :web,                  production_domain
  role :app,                  production_domain
  role :db,                   production_domain, :primary => true, :db_dump => true
end

desc "Staging deploys"
task :staging do
  set  :user,                 "deploy"
  set  :password,             "PASSWORD"

  set  :branch,               "staging"
  set  :deploy_to,            "/var/www/apps/#{application}"
  set  :deployment,           "staging"
  set  :staging_domain,       "EXAMPLE.COM"

  set  :domain,               staging_domain
  role :web,                  staging_domain
  role :app,                  staging_domain
  role :db,                   staging_domain, :primary => true, :db_dump => true
end

before  "deploy",                 "deploy:campfire_announce_before"
before  "deploy:migrations",      "deploy:campfire_announce_before"
after   "deploy:symlink_configs", "deploy:symlink_app_configs", "deploy:update_revisions_log"

common_after_deploy_tasks = [
#   "deploy:index_sphinx",
  "deploy:generate_static_pages",
  "deploy:tag",
  "deploy:campfire_announce_after",
  "deploy:email_notify",
  "deploy:cleanup"
]

after   "deploy",                 *common_after_deploy_tasks
after   "deploy:migrations",      *common_after_deploy_tasks
after   "deploy:long",            *common_after_deploy_tasks
after   "deploy:update_code",     "deploy:symlink_configs"

# =============================================================================

namespace :campfire do
  desc "Announce message to Campfire"
  task :announce do
    require 'tinder'
    campfire  = Tinder::Campfire.new 'eastmedia', :ssl => true
    campfire.login 'bot-em@eastmedia.com', 'potatoface'
    room = campfire.find_room_by_name "ROOM_NAME"
    room.speak campfire_message
    set :campfire_message, "None"
  end
end

namespace :deploy do
  task :index_sphinx, :roles => :app, :except => {:no_symlink => true} do
    run <<-CMD
      cd #{current_path} && RAILS_ENV=production rake ts:in
    CMD
  end
  
  task :symlink_app_configs, :roles => :app, :except => {:no_symlink => true} do
    run <<-CMD
    ln -nsf #{shared_path}/config/settings.yml           #{release_path}/config/settings.yml && 
    ln -nsf #{shared_path}/config/production.sphinx.conf #{release_path}/config/production.sphinx.conf && 
    ln -nfs #{shared_path}/public/assets                 #{release_path}/public/assets
    CMD
  end
  
  task :campfire_announce_before do
    set :campfire_message, "About to deploy #{application} #{deployment.upcase} from r#{real_revision} by #{ENV['USER']}."
    campfire.announce
  end
  
  task :campfire_announce_after do
    set :campfire_message, "Completed deploying #{application} #{deployment.upcase} from r#{real_revision} by #{ENV['USER']} to http://#{domain}"
    campfire.announce
  end
  
  task :update_revisions_log, :roles => :app, :except => { :no_release => true } do
    run "(test -e #{deploy_to}/revisions.log || (touch #{deploy_to}/revisions.log && chmod 666 #{deploy_to}/revisions.log)) && " +
    "echo `date +\"%Y-%m-%d %H:%M:%S\"` $USER #{real_revision} #{File.basename(release_path)} >> #{deploy_to}/revisions.log;"
  end
  
  desc "Send email notification of deployment"
  task :email_notify, :roles => :app do
    require 'action_mailer' unless defined?(ActionMailer)
    require 'config/recipes/mailer'
    require 'app/mailers/deploy_mailer'
    
    run "#{current_path}/script/runner -e production 'DeployMailer.deliver_deployment_notification(\"#{deployment}\", \"#{domain}\")'"
    puts "Deploy notification for #{deployment.upcase} sent"
  end

  desc "Generate the static error pages: 404, etc."
  task :generate_static_pages, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=production rake static_templates:generate"
  end

  desc "Tag a deployment with the date, time, and environment.  In utc."
  task :tag do
    if deployment == "production"
      time = Time.now.utc.strftime("%Y.%m.%d.%H.%M")
      `git tag #{deployment}.#{time}`
      `git push --tags`
    end
  end
end

namespace :remote do
  desc "Remote console"
  task :console, :roles => :db, :only => { :primary => true } do
    input = ''
    run "cd #{current_path} && ./script/console production" do |channel, stream, data|
      next if data.chomp == input.chomp || data.chomp == ''
      print data
      channel.send_data(input = $stdin.gets) if data =~ /^(>|\?)>/
    end
  end
end

namespace :db do
  desc <<-HERE
    Dump the database from the environment specified, and transfer it to
    the project root with scp.

    This is an alias for database:dump_and_transfer
  HERE
  task :dump_and_transfer do
    database.dump_and_transfer
  end

  desc <<-HERE
    Dump the database from the environment specified, and transfer it to
    the project root with scp.  When done, run rake db:recreate_from_dump,
    which drops the development database, and recreates it with the db dump

    This is an alias for database:dump_and_transfer
  HERE
  task :dump_transfer_and_import do
    dump_and_transfer
    puts `rake db:recreate_from_dump`
  end
end

namespace :performance do
  desc "Analyze Rails Log instantaneously"
  task :pl_analyze, :roles => :app do
    run "pl_analyze #{shared_path}/log/production.log" do |ch, st, data|
      print data
    end
  end

  desc "Run rails_stat"
  task :rails_stat, :roles => :app do
    stream "rails_stat #{shared_path}/log/production.log"
  end
end
