module Addressable
  
  [:street1, :street2, :city, :state, :postal_code, :country].each do |address_attr|
    define_method(address_attr) do
      if address
        address.__send__(address_attr)
      else
        read_attribute(address_attr)
      end
    end
    
    define_method("#{address_attr}=") do |*values|
      self.address ||= Address.new(:user_id => self.user_id)
      self.address.__send__("#{address_attr}=", *values)
    end
  end
  
end
