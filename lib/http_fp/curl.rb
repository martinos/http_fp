require 'net/http'
require 'http_fp'

module HttpFp::Curl
  include HttpFp

  mattr_accessor :print_curl

  @@to_curl = -> req {
    %{curl -X '#{req[:method]}' '#{to_uri.(req).to_s}' #{req[:header].map(&@@header_to_curl).join(" ")}}
  }
  @@header_to_curl = -> a {
    "\\\n    -H '#{a[0]}: #{a[1]}'"}
  
  @@print_curl = -> print, req { print.(to_curl.(req)) ; req}.curry
end
