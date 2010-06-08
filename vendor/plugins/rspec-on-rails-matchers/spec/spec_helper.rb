require 'action_controller'
require 'active_record'
require 'spec/rails/matchers'
require File.expand_path(File.dirname(__FILE__) + "/../init")

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database  => ':memory:'
ActiveRecord::Migration.verbose = false

class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :commentable, :polymorphic => true

  validates_presence_of :post

  attr_accessor :an_attr_accessor
end

class Image < ActiveRecord::Base
  has_one :comment, :as => :commentable
end

class Post < ActiveRecord::Base
  has_many :comments
end

class Boolean < ActiveRecord::Base
  validates_inclusion_of :null_not_allowable, :in => [true, false]
end

class InvalidAssociationClass < ActiveRecord::Base
  set_table_name "invalid_association"

  has_many :foos
end

ActiveRecord::Schema.define do
  create_table :booleans do |t|
    t.boolean :null_allowable
    t.boolean :null_not_allowable
  end

  create_table :posts do |t|
    t.string :name
  end

  create_table :comments do |t|
    t.string  :text
    t.integer :post_id
    t.integer :commentable_id
    t.string  :commentable_type
  end

  create_table :images do |t|
    t.string :image_id
  end

  create_table :invalid_association, :force => true do |t|
    t.timestamps
  end
end
