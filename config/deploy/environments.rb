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
