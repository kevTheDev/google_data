require 'bundler'
require "bundler/setup"
require 'test/unit'
require 'active_support'
require 'rr'
require 'shoulda'
require 'factory_girl'

require 'google_data'


require 'factories'

class ActiveSupport::TestCase
  
  include RR::Adapters::TestUnit
  
  Factory.find_definitions 
  

end