
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
    sh("script/import_db #{latest_database_dump}")
  end

private
  
  DATABASE_DUMP_PREFIX = ""
  
  def latest_database_dump
    database_dumps.sort.last
  end
  
  def database_dumps
    Dir.glob("#{RAILS_ROOT}/#{DATABASE_DUMP_PREFIX}*")
  end
end
