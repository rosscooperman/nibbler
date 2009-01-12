desc "CruiseControl build"
task :cruise do
  Rake::Task['db:recreate_with_migrations'].invoke
  Rake::Task['db:test:prepare'].invoke

  ENV['RAILS_ENV'] = RAILS_ENV = 'test'

  errors = %w(spec).collect do |task|
    begin
      Rake::Task[task].invoke
      nil
    rescue => e
      task
    end
  end.compact
  abort "Errors running #{errors.to_sentence}!" if errors.any?
end