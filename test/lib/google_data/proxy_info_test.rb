require 'test_helper'



module GoogleData

  class ProxyInfoTest < ActiveSupport::TestCase
    
    context 'creation' do
      
      should 'raise an ArgumentError error if no address given' do
        assert_raises(ArgumentError) { ProxyInfo.new }
      end
      
      should 'raise an InvalidProxyAddress if the address is empty?' do
        assert_raises(InvalidProxyAddress) { ProxyInfo.new('') }
      end
      
      should 'raise an InvalidProxyAddress if the address is nil?' do
        assert_raises(InvalidProxyAddress) { ProxyInfo.new(nil) }
      end
      
      should 'not raise an error if there is an address' do
        assert_nothing_raised { ProxyInfo.new('www.example.com') }
      end
      
    end
    
  end

end