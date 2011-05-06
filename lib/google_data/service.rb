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
require 'google_data/base' 

module GoogleData
  #The service class is the main handler for all direct interactions with the 
  #Google Data API.
  
  class Service < Base
    #Convenience attribute contains the currently authenticated account name
    attr_reader :account
    
    # The token returned by the Google servers, used to authorize all subsequent messages
    attr_reader :auth_token
    
    #Accepts an optional attributes hash for initialization values, most likely :google_data_version
    def initialize(attributes = {})
      super(attributes)
      attributes.each do |key, value|
        self.send("#{key}=", value)
      end    
    end
    
    # The authenticate method passes the username and password to google servers.  
    # If authentication succeeds, returns true, otherwise raises the AuthenticationFailed error.
    # Thanks to David King and Scott Taylor for Ruby 1.9 fix.
    
    # google_service e.g. cl == Google Calendar
    def authenticate(username, password, google_service, source='GoogleData')
      reset_auth_token
      response = send_request(Request.new(:post, AUTH_URL, "Email=#{username}&Passwd=#{password}&source=#{source}&service=#{google_service}&accountType=HOSTED_OR_GOOGLE"))
      
      raise AuthenticationFailed if response.class != Net::HTTPOK
      parse_successful_response(response)
    end
    
    private
    
    def reset_auth_token
      @auth_token = nil
    end
    
    def parse_successful_response(response)
      body = response.read_body
      lines = body.send(body.respond_to?(:lines) ? :lines : :to_s).to_a
      @auth_token = lines.to_a[2].gsub("Auth=", "").strip
      @account = username
      @password = password
      return true
    end
    
    
  end
end