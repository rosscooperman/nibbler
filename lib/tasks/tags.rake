namespace :tags do
  task :emacs do
    puts "Making Emacs TAGS file"
    sh "find . | grep -e 'rb$' | xargs ctags -e"
  end
end

desc "Build the emacs tags file"
task :tags => ["tags:emacs"]
