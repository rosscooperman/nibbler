namespace :sync do
  # You'll need to fill in the SSH_KEYNAME, which is the name of the slice
  # in your .ssh/config
  PRODUCTION_SLICE_TO_SYNC_FROM = "SSH_KEYNAME"
  
  # Fill in the APP_NAME, or change the path of the app on the server
  SHARED_PATH = '/var/www/apps/APP_NAME/current/public'
  LOCAL_SHARED_PATH = RAILS_ROOT + "/public"
  
  # This is the list of dirs inside public that you'll sync
  static_dirs = [:assets]

  static_dirs.each do |static_dir|
    desc <<-DESC
      Sync #{static_dir} to local environment

      You'll need to add a '#{PRODUCTION_SLICE_TO_SYNC_FROM}' entry to your
      ssh_config (and have ssh access to the server)
      for these tasks to work
    DESC
    task static_dir do
      puts "** About to sync #{static_dir}"
      # Use --whole-file so that we don't need to diff the files.  Good for binary files
      # Use proper slashes so that we don't overwrite the symlink
      command = "rsync -avz --whole-file --delete -P #{PRODUCTION_SLICE_TO_SYNC_FROM}:#{SHARED_PATH}/#{static_dir}/ '#{LOCAL_SHARED_PATH}/#{static_dir}'"
      puts "COMMAND: #{command}"
      system command
      puts "** Done syncing #{static_dir}"
    end
  end

  desc "Syncs all directories in public (#{static_dirs.join(", ")})"
  task :all => static_dirs
end

desc "Sync all static directories"
task :sync => "sync:all"
