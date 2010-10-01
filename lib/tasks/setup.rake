
task :setup_project do
  def mkdir(dir)
    puts "* Creating dir #{dir}"
    sh "mkdir -p #{Rails.root}/#{dir}"
  end

  def cp(source, directory)
    puts "* cp'ing #{source} to #{directory}"
    sh "cp #{source} #{directory}"
  end

  mkdir "app/models"
  mkdir "tmp"
  cp    "config/database.example.yml", "config/database.yml"
  cp    "spec/spec.opts.template",     "spec/spec.opts"
end
