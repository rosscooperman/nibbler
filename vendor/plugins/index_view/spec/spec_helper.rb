require File.dirname(__FILE__) + "/../lib/index_view"

require 'rubygems'
require 'sqlite3'
require 'active_record'
require 'active_support'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database  => ':memory:'
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :first_name
    t.string :last_name
    t.string :email
    t.timestamps
  end
end

class User < ActiveRecord::Base; end