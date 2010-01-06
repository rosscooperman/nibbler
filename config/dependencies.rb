Dir.glob(File.join(RAILS_ROOT, "vendor", "dependencies", "**", "lib")).each do |dir|
  $LOAD_PATH.unshift dir
end

autoload :Diff, "diff/lcs"