require 'test_helper'



module GoogleData

  class ServiceTest < ActiveSupport::TestCase
    
    context 'parse_auth_token' do
      
      setup do
        @service = Service.new({:google_data_version => '3.0'})
        @valid_body = ["SID=DQAAAGgA...7Zg8CTN", "LSID=DQAAAGsA...lk8BBbG", "Auth=DQAAAGgA...dk3fA5N"]
        
      end
      
      should 'raise AuthenticationFailed if response_body_lines size != 3' do
        assert_raises(AuthenticationFailed) { @service.parse_auth_token([]) }
      end
      
      should 'raise AuthenticationFailed if response_body_lines[2] does not include Auth=' do
        assert_raises(AuthenticationFailed) { @service.parse_auth_token(['', '', '']) }
      end
      
      should 'set the @auth_token' do
        @service.parse_auth_token(@valid_body)
        
        assert_equal 'DQAAAGgA...dk3fA5N', @service.auth_token
      end
      
    end
    
    context 'parse_body' do
      
      setup do
        @service = Service.new({:google_data_version => '3.0'})
      end
      
      should 'return an array of size 3' do
        body = "SID=DQAAAGgA...7Zg8CTN
                 LSID=DQAAAGsA...lk8BBbG
                 Auth=DQAAAGgA...dk3fA5N"
        
        parsed_body = @service.parse_body(body)
        assert parsed_body.is_a?(Array)
        assert_equal 3, parsed_body.size
      end
      
      should 'return an empty array if body is nil' do
        parsed_body = @service.parse_body(nil)
        assert parsed_body.empty?
      end
      
      should 'return an empty array if body string is empty' do
        parsed_body = @service.parse_body('')
        assert parsed_body.empty?
      end
    end
    
    
    context 'parse_response' do
      
      setup do
        @service = Service.new({:google_data_version => '3.0'})
        
        @response = Object.new
      end
      
      should 'raise AuthenticationFailed if response is not Net::HTTPOK' do
        stub(@response).class { Net::HTTPBadRequest }
        
        stub(@service).send_request { @response }
        assert_raises(AuthenticationFailed) { @service.parse_response(@response) }
      end
      
      should 'not raise an error if the response is Net::HTTPOK' do
        stub(@response).class { Net::HTTPOK }
        stub(@service).parse_successful_response(@response) { true }
        assert_nothing_raised { @service.parse_response(@response) }
      end
      
      should 'call parse_successful_response if the response is Net::HTTPOK' do
        stub(@response).class { Net::HTTPOK }
        mock(@service).parse_successful_response(@response) { true }.once
        
        @service.parse_response(@response)
      end
      
    end
    
  end

end