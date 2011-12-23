namespace :tire do

  def say_with_time(message)
    puts "=== #{message}"
    start = Time.now
    yield
    finish = Time.now
    puts " -> #{finish - start}s"
  end

  desc 'Reindex everything!'
  task :reindex => :environment do
    Dir[Rails.root.join('app', 'models', '**', '*.rb')].each do |file|
      klass = File.basename(file).gsub(/\.rb$/, '').camelize.constantize
      if klass.respond_to?(:tire)
        say_with_time("Reindexing '#{klass}'...") do
          klass.tire.index.import(klass.all)
        end
        puts "=== Done!"
      end
    end
  end
end
