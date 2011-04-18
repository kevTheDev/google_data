require 'test_helper'



module GoogleData

  class RequestTest < ActiveSupport::TestCase
    
    context 'initialize' do
      should 'raise an ArgumentError if type is not valid' do
        assert_raises(ArgumentError) { GoogleData::Request.new(:blag, 'http://www.google.com') }
      end
    end
    
    context 'instance methods' do
      setup { @request = GoogleData::Request.new(:get, 'http://www.google.com') }
    
      context 'type=' do
        
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
        
        should 'raise an ArgumentError if passed parameters is nil' do
          assert_raises(ArgumentError) { @request.parameters = nil }
        end
        
        should 'raise an ArgumentError if passed parameters is not a Hash' do
          assert_raises(ArgumentError) { @request.parameters = '' }
        end
        
        should 'not raise an ArgumentError if passed parameters is a Hash' do
          assert_nothing_raised { @request.parameters = { } }
        end
      end
      
      context 'parameters' do
        
        should 'return a blank string if the parameters hash is empty' do
          assert_equal '', @request.parameters
        end
        
      end
      
    end
    
  end

end