module GoogleData
  
  #The ProxyInfo class contains information for configuring a proxy connection
  class ProxyInfo
    attr_accessor :address, :port, :username, :password

    #The initialize function accepts four variables for configuring the ProxyInfo object.  
    #The proxy connection is initiated using the builtin Net::HTTP proxy support.
    def initialize(address, port, username=nil, password=nil)
      @address  = address
      @port     = port
      @username = username
      @password = password
    end
  end
  
  
end