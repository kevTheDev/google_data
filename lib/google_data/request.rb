require "uri"

module GoogleData
  #The Request class holds all information needed to make a Request to a Google service.
  class Request
    #The HTTP request type, must be one of :get, :post, :put, :delete
    attr_reader :type
    
    #The HTTP request content, only valid for :put and :post requests
    attr_accessor :content
    
    #Optional.  Additional headers to pass with the request.
    attr_accessor :headers
    
    #Optional.  Additional query parameters (i.e. "?param=value") to append to the request url
    attr_reader :parameters
    
  
    #Creates a new request object.
    def initialize(type, url, content = nil, headers = nil, query_parameters = nil)
      self.headers = headers
      self.content = content
      self.type = type
      self.parameters = query_parameters
      self.url = url
    end
    
    def type=(type)
      raise ArgumentError unless [:get, :post, :put, :delete].include?(type)
      @type = type
    end
    
    #A hash of additional query parameters (i.e. {'param' => 'value') to append to the request url
    def parameters=(query_parameters)
      raise ArgumentError, 'Query parameters must be a Hash' if !query_parameters.nil? && !query_parameters.is_a?(Hash)
      @parameters = "?#{query_parameters.to_a.collect{|a| a.join("=")}.join("&")}"
    end
    
    #The HTTP url to send the request to
    def url
      return URI.parse("#{@url+(@parameters ? @parameters : '')}")
    end
    
    def url=(url)
      @url = URI.parse(url)
    end
  end
end