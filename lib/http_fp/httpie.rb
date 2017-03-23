require 'net/http'
require 'http_fp'

module HttpFp::Httpie
  include HttpFp

  mattr_accessor :print_curl, :req

  @@req = -> req {
    first_part = %{http --json #{req[:method]} '#{HttpFp::to_uri.(req).to_s}' #{req[:header].map(&@@header_to_curl).join(" ")}}
    if req[:body] && !req[:body].empty?
      first_part + %{ \\\n    $'#{req[:body].gsub("'", "\'")}'}
    else
      first_part
    end
  }
  @@header_to_curl = -> a {
    "\\\n    '#{a[0]}: #{a[1]}'"}
end
