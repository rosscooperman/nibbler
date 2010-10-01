namespace :db do
  desc "Recreate the database running drop, and then recreate"
  task :recreate => [:drop, :create]

  desc "Recreate the database recreate and then running migrations"
  task :recreate_with_migrations => [:drop, :create, :migrate]

  desc <<-HERE
    Create the database from a sql file.

    Drop the database, recreate it from the most recent database dump.
    Run migrations once done
  HERE
  task :recreate_from_dump => [:recreate, :import_db]

  desc <<-HERE
    Import the database from the most recent database dump.
  HERE
  task :import_db do
    sh("script/etc/import_db #{latest_database_dump}")
  end

  desc "drop, create, migrate, and seed"
  task :reboot => [:drop, :create, :migrate, :seed]

private

  def latest_database_dump
    database_dumps.sort.last
  end

  def database_dumps
    Dir.glob("#{Rails.root}/#{database_dump_prefix}*")
  end

  def database_dump_prefix
    raise "Must set database dump file name prefix (e.g. 'flavorpill' for 'flavorpill_production_dump_2009-07-29-14:42:04.sql')"
  end
end
