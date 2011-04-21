require 'bundler'
require "bundler/setup"
require 'test/unit'
require 'active_support'
require 'rr'
require 'shoulda'

require 'google_data'


class ActiveSupport::TestCase
  
  include RR::Adapters::TestUnit
  
end