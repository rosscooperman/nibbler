module Authorization
  module ClassMethods
    def restrict(*actions, &block)
      method_name = "restriction_#{rand(5000)}".to_sym
      filter_name = "#{method_name}_filter".to_sym
      
      define_method(method_name, &block)
      define_method(filter_name) { restrict_action(method_name) }
      
      logger.warn "Adding filter #{filter_name} with options #{filter_options(actions).inspect}"
      before_filter(filter_name, filter_options(actions))
    end

    def clear_restrictions(*actions)
      restriction_filters.each do |restriction_filter|
        skip_before_filter(restriction_filter, filter_options(actions))
      end
    end
    
  protected
  
    def filter_options(actions)
      hash = {}
      
      if actions.first.is_a?(Hash)
        hash[:only] = actions.first[:only] if actions.first[:only]
        hash[:except] = actions.first[:except] if actions.first[:except]
      elsif !actions.empty?
        hash[:only] = actions
      end
      
      hash
    end
    
    def restriction_filters
      filter_chain.map(&:filter).map(&:to_s).select { |f| f.starts_with?("restriction_") }.map(&:to_sym)
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  def restrict_action(method_name)
    unless send(method_name)
      logger.warn "#{method_name} failed!"
      authorization_denied
    end
  # rescue
    # authorization_denied
  end
  
  def authorization_denied
    redirect_to "/403"
    false
  end
end