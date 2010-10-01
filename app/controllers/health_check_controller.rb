class HealthCheckController < ApplicationController
  def ok
    render :text => "OK", :layout => false
  end

  def error
    raise "An error for testing hoptoad"
  end

  # need to instantiate an AR class to perform a generic db query -
  # ActiveRecord::Base.count_by_sql will raise an error about it being an abstract class.
  class ARQuery < ActiveRecord::Base; end

  def health_check
    unless ARQuery.count_by_sql("SELECT COUNT(*) FROM schema_migrations") > 1
      raise "Schema table not working"
    end

    unless File.exists?(File.join(Rails.root, "config", "database.yml"))
      raise "database.yml doesn't exist!"
    end

    render :text => "OK", :layout => false
  rescue Exception => e
    render :text => "Error: #{e}", :layout => false
  end
end