after "deploy:symlink_configs", "deploy:symlink_app_configs"

common_after_deploy_tasks = [
  "deploy:tag",
  "deploy:email_notify",
  "data:create_example_admin"
]

after   "deploy",                 *common_after_deploy_tasks
after   "deploy:migrations",      *common_after_deploy_tasks
after   "deploy:long",            *common_after_deploy_tasks
after   "deploy:update_code",     "deploy:symlink_configs"
after   "deploy:setup",           "deploy:setup_directory_permissions", "deploy:setup_shared_directories"
