module GitRevision
  extend self

  def revision_html
    @git_version_html ||= "<!-- branch: #{branch_name}, revision: #{version} -->"
  end

  def branch_name
    `git branch`.split("\n").detect { |b| b =~ /^\*/ }.gsub(/\*/, "").strip
  rescue
    "UNKNOWN"
  end

  def version
    `git rev-list HEAD | head -n 1`.strip
  rescue
    "UNKNOWN"
  end
end
