# Author:: Mike Reich (mike@seabourneconsulting.com)
# Copyright:: Copyright (C) 2010 Mike Reich
# License:: GPL v2
#--
# Licensed under the General Public License (GPL), Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
# Feel free to use and update, but be sure to contribute your
# code back to the project and attribute as required by the license.
#++

require 'net/http'
require 'net/https'
require 'time'
require 'cgi'

require 'google_data/request'
require 'google_data/proxy_info'
require 'google_data/utils/utils'

require 'rexml/document'

Net::HTTP.version_1_2

# GoogleData is a full featured wrapper for the base google data API

module GoogleData
  
  class AuthenticationFailed < StandardError; end #:nodoc: all

  class NotAuthenticated < StandardError; end
    
  class InvalidService < StandardError; end
    
  class HTTPRequestFailed < StandardError; end
    
  class QueryParameterError < StandardError; end

  
  
  #The Base class includes the basic HTTP methods for communicating with the Google Data API.
  #You shouldn't use this class directly, rather access the functionality through 
  #the Service subclass.

  class Base
    AUTH_URL = "https://www.google.com/accounts/ClientLogin"
    @proxy_info = nil
    @auth_token = nil
    @debug = false
    @google_data_version = '2.1'

    #Contains the ProxyInfo object for using a proxy server
    attr_accessor :proxy_info
    
    #If set to true, debug will dump all raw HTTP requests and responses
    attr_accessor :debug
    
    #The GData version used by the service
    attr_accessor :google_data_version

    #Optionally, pass a hash of attributes to populate the class.  If you want to use a GData version
    #other than the default (2.1), pass a key/value pair, i.e. {:google_data_version => '1.0'}      
    def initialize(attributes = {})
      @google_data_version = attributes[:google_data_version] ? attributes[:google_data_version] : '2.1'
    end
    
    #Sends a request to the Google Data System.  Accepts a valid Request object, and returns a 
    #HTTPResult class.
    def send_request(request)
      raise ArgumentError 'Request must be a GoogleData::Request object' if not request.is_a?Request
      puts "sending #{request.type} to url = #{request.url.to_s}" if @debug
      do_request(request)
    end

    private

    def do_request(request)
      ret = nil
      add_auth_header(request)
      http = get_http_object(request.url)
      puts "Sending request\nHeader: #{request.headers.inspect.to_s}\nContent: #{request.content.to_s}\n" if @debug
      http.start do |ht|
        if request.is_publish_request?
          ret = ht.send(request.type, request.url.to_s, request.content, request.headers)
        else
          ret = ht.send(request.type, request.url.to_s, request.headers)
        end
      end
      
      while ret.is_a?(Net::HTTPRedirection)
        puts "Redirect received, resending request" if @debug
        request.parameters = nil
        request.url = ret['location']
        puts "sending #{request.type} to url = #{request.url.to_s}" if @debug
        ret = do_request(request)
      end
      if not ret.is_a?(Net::HTTPSuccess)
        puts "invalid response received: "+ret.code if @debug
        raise HTTPRequestFailed, ret.body
      end
      puts "20x response received\nResponse: \n"+ret.read_body if @debug
      return ret
    end

    def get_http_object(location)
      if valid_proxy?
	      http = Net::HTTP.new(location.host, location.port, @proxy_info.address, @proxy_info.port, @proxy_info.username, @proxy_info.password)
      else
	     http = Net::HTTP.new(location.host, location.port)
	    end
      if location.scheme == 'https'
        #fixed http/http misnaming via JohnMetta
        puts "SSL True" if @debug
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      return http
    end
    
    def add_auth_header(request)
      if @auth_token
        if request.headers
          request.headers.merge!({'Authorization' => "GoogleLogin auth=#{@auth_token}", "GData-Version" => @google_data_version})
        else 
          content_type = (request.type == :get or request.type == :delete) ? 'application/x-www-form-urlencoded' : 'application/atom+xml'
          request.headers = {'Authorization' => "GoogleLogin auth=#{@auth_token}", "GData-Version" => @google_data_version, 'Content-Type' => content_type}
        end
      end
    end
    
    def valid_proxy?
      @proxy_info
    end
    
  end
end