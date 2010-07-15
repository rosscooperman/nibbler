module GitRevision
  extend self

  def revision_html
    @git_version_html ||= "<!-- branch: #{branch_name}, revision: #{version}, host: #{hostname} -->"
  end

  def hostname
    `hostname`.strip
  rescue
    "UNKNOWN"
  end

  def branch_name
    `#{git_path} branch`.split("\n").detect { |b| b =~ /^\*/ }.gsub(/\*/, "").strip
  rescue
    "UNKNOWN"
  end

  def version
    `#{git_path} rev-list HEAD | head -n 1`.strip
  rescue
    "UNKNOWN"
  end

private

  def git_path
    @git_path ||= begin
      git_path = `which git`.strip
      git_path.empty? ? "/usr/local/bin/git" : git_path
    end
  end
end
