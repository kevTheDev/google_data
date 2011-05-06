require 'test_helper'



module GoogleData

  class ServiceTest < ActiveSupport::TestCase
    
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