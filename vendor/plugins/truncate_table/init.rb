
require File.dirname(__FILE__) + "/lib/truncate_table"

ActiveRecord::Base.extend TruncateTable
