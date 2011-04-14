Factory.define(:request, :class => 'GoogleData::Request') do |f|
  f.type  :get
  f.url   'http://www.google.com'
end