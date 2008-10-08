namespace :git do
  namespace :submodules do
    desc "Register submodules"
    task :init do
      sh "git submodule init"
    end

    desc "Update submodules"
    task :update do
      sh "git submodule update"
    end
  end
end

desc "Fetch all submodules"
task :git => ["git:submodules:init", "git:submodules:update"]
