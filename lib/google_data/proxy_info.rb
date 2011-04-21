module GoogleData
  
  class InvalidProxyAddress < StandardError; end
  
  #The ProxyInfo class contains information for configuring a proxy connection
  class ProxyInfo
    
    attr_accessor :port, :username, :password
    
    attr_reader   :address

    #The initialize function accepts four variables for configuring the ProxyInfo object.  
    #The proxy connection is initiated using the builtin Net::HTTP proxy support.
    def initialize(address, port=nil, username=nil, password=nil)
      self.address  = address
      self.port     = port
      self.username = username
      self.password = password
    end
    
    def address=(address)
      raise InvalidProxyAddress, 'Address is empty' if address.blank?
      @address = address
    end
    
  end
  
  
end