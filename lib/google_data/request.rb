require "uri"

module GoogleData
  #The Request class holds all information needed to make a Request to a Google service.
  class Request
    #The HTTP request type, must be one of :get, :post, :put, :delete
    attr_reader :type
    
    #The HTTP request content, only valid for :put and :post requests
    attr_reader :content
    
    #Optional.  Additional headers to pass with the request.
    attr_accessor :headers
    
    #Optional.  Additional query parameters (i.e. "?param=value") to append to the request url
    attr_reader :parameters
    
  
    #Creates a new request object.
    def initialize(type, url, content = '', headers = {}, query_parameters = {})
      self.type = type
      self.url = url
      self.content = content if is_publish_request?
      self.headers = headers
      self.parameters = query_parameters
    end
    
    def type=(type)
      raise ArgumentError, 'Invalid HTTP request type' unless [:get, :post, :put, :delete].include?(type)
      @type = type
    end
    
    #A hash of additional query parameters (i.e. {'param' => 'value') to append to the request url
    def parameters=(query_parameters)
      raise ArgumentError, 'Query parameters must be a Hash' unless query_parameters.is_a?(Hash)
      @parameters = "?#{query_parameters.to_a.collect{|a| a.join("=")}.join("&")}"
    end
    
    def parameters
      @parameters == '?' ? '' : @parameters
    end
    
    def is_publish_request?
      [:post, :put].include?(self.type)
    end
    
    def content=(content)
      is_publish_request? ? @content = content : @content = ''
    end
    
    #The HTTP url to send the request to
    def url
      URI.parse("#{@url}#{self.parameters}")
    end
    
    def url=(url)
      @url = URI.parse(url)
    end
  end
end