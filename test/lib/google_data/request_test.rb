require 'test_helper'



module GoogleData

  class RequestTest < ActiveSupport::TestCase
    
    context 'initialize' do
      should 'raise an ArgumentError if type is not valid' do
        assert_raises(ArgumentError) { GoogleData::Request.new(:blag, 'http://www.google.com') }
      end
    end
    
    context 'type=' do
      
      setup { @request = GoogleData::Request.new(:get, 'http://www.google.com') }
      
      should 'allow type == :get' do
        assert_nothing_raised { @request.type = :get }
      end
      
      should 'allow type == :post' do
        assert_nothing_raised { @request.type = :post }
      end
      
      should 'allow type == :put' do
        assert_nothing_raised { @request.type = :put }
      end
      
      should 'allow type == :delete' do
        assert_nothing_raised { @request.type = :delete }
      end
      
      should 'raise an ArgumentError if type is not valid' do
        assert_raises(ArgumentError) { @request.type = :got }
      end
    end
    
    context 'parameters=' do
      setup { @request = GoogleData::Request.new(:get, 'http://www.google.com') }
      
      should 'raise an ArgumentError if passed parameters is not a Hash' do
        assert_raises(ArgumentError) { @request.parameters = '' }
      end
      
      should 'not raise an ArgumentError if passed parameters is a Hash' do
        assert_nothing_raised { @request.parameters = { } }
      end
    end
    
  end

end