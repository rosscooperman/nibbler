module TruncateTable
  module Version
    MAJOR = 1
    MINOR = 0
    TINY  = 0

    VERSION = "#{MAJOR}.#{MINOR}.#{TINY}"
  end

  def truncate_table!
    begin
      connection.execute("TRUNCATE TABLE `#{table_name}`")
    rescue
      connection.execute("DELETE FROM `#{table_name}`")
    end
  end
end
