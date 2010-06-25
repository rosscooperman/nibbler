namespace :data do
  desc "Create example admin user (admin@example.com, pw: 'password')"
  task :create_example_admin => :environment do
    if Administrator.find_by_email("admin@example.com")
      puts "* Example admin already exists"
    else
      puts "* Creating example admin"
      FixtureReplacement.create_example_admin
    end
  end
end
