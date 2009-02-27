
require "rubygems"
require "spec"

require "active_record"
require File.dirname(__FILE__) + "/../init"

require 'sqlite3'

module SpecHelpers
  class << self
    def setup_sqlite
      setup_db(:sqlite)
    end

    def setup_mysql
      setup_db(:mysql)
    end

    def setup_db(db)
      db_file = File.dirname(__FILE__) + "/#{db}_connection.yml"
      ActiveRecord::Base.establish_connection YAML.load(File.read(db_file))
      ActiveRecord::Migration.verbose = true

      ActiveRecord::Schema.define do
        create_table :users, :force => true do |t|
          t.column  :username,  :string
          t.timestamps
        end

        create_table :others, :force => true do |t|
          t.timestamps
        end
      end
    end
  end
end

class User < ActiveRecord::Base; end
class Other < ActiveRecord::Base; end
