namespace :deploy do
  task :symlink_app_configs, :roles => :app, :except => {:no_symlink => true} do
    run <<-CMD
    ln -nsf #{shared_path}/config/settings.yml           #{release_path}/config/settings.yml &&
    ln -nfs #{shared_path}/public/assets                 #{release_path}/public/assets
    CMD
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

  task :setup_directory_permissions do
    sudo "chown -R #{user}:#{user} #{deploy_to}"
  end

  task :setup_shared_directories do
    run "mkdir -p #{shared_path}/config"
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
