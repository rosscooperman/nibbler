namespace :deploy do
  task :symlink_app_configs, :roles => :app, :except => {:no_symlink => true} do
    run [
      "ln -nsf #{shared_path}/config/settings.yml           #{release_path}/config/settings.yml"
    ].join(" && ")
  end

  desc "Send email notification of deployment"
  task :email_notify, :roles => :app do
    require 'action_mailer' unless defined?(ActionMailer)
    require 'config/recipes/mailer'
    require 'app/mailers/deploy_mailer'

    run "#{current_path}/script/runner -e #{rails_env} 'DeployMailer.deliver_deployment_notification(\"#{deployment}\", \"#{domain}\")'"
    puts "Deploy notification for #{deployment.upcase} sent"
  end

  desc "Generate the static error pages: 404, etc."
  task :generate_static_pages, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} rake static_templates:generate" do |_, _, data|
      print data
    end
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

  task :delete_compressed_assets do
    files = [
      "#{current_path}/public/javascripts/all.js",
      "#{current_path}/public/stylesheets/all.css"
    ].join(" ")

    run "rm -rf #{files}"
  end
end

namespace :remote do
  desc "Remote console"
  task :console, :roles => :db, :only => { :primary => true } do
    input = ''
    run "cd #{current_path} && ./script/console #{rails_env}" do |channel, stream, data|
      next if data.chomp == input.chomp || data.chomp == ''
      print data
      channel.send_data(input = $stdin.gets) if data =~ /^(>|\?)>/
    end
  end

  task :reboot do
    if rails_env == "staging"
      run "cd #{current_path} && RAILS_ENV=#{rails_env} rake db:reboot"
    else
      warn "Skipping reboot task.  This isn't staging!!!"
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
    run "pl_analyze #{shared_path}/log/#{rails_env}.log" do |ch, st, data|
      print data
    end
  end

  desc "Run rails_stat"
  task :rails_stat, :roles => :app do
    stream "rails_stat #{shared_path}/log/#{rails_env}.log"
  end
end

namespace :data do
  desc "Create the example admin (in staging, only)"
  task :create_example_admin do
    if deployment == "staging"
      run "cd #{current_path} && RAILS_ENV=#{rails_env} rake data:create_example_admin"
    end
  end
end
