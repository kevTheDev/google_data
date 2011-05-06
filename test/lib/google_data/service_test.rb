require 'test_helper'



module GoogleData

  class ServiceTest < ActiveSupport::TestCase
    
    
    context 'authenticate' do
      
      setup do
        @service = Service.new({:google_data_version => '3.0'})
        stub(@service).parse_successful_response { true }
        
        @response = Object.new
      end
        
      
      should 'raise AuthenticationFailed if response is not Net::HTTPOK' do
        stub(@response).class { Net::HTTPBadRequest }
        
        stub(@service).send_request { @response }
        assert_raises(AuthenticationFailed) { @service.authenticate('kdog', 'password', 'cl') }
      end
      
      should 'not raise an error if the response is Net::HTTPOK' do
        stub(@response).class { Net::HTTPOK }
        
        stub(@service).send_request { @response }
        assert_nothing_raised { @service.authenticate('kdog', 'password', 'cl') }
      end
      
    end
    
  end

end