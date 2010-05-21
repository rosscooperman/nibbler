after "deploy:symlink", "deploy:symlink_app_configs"

common_after_deploy_tasks = [
  "deploy:tag",
  "deploy:email_notify",
  "data:create_example_admin"
]

after   "deploy",                 *common_after_deploy_tasks
after   "deploy:migrations",      *common_after_deploy_tasks
after   "deploy:long",            *common_after_deploy_tasks
after   "deploy:setup",           "deploy:setup_directory_permissions", "deploy:setup_shared_directories"
