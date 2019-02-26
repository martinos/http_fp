require "net/http"
require "http_fp"

module HttpFp::Httpie
  include HttpFp

  fn_reader :print_curl, :req

  @@req = -> req {
    first_part = %{http #{req[:method]} '#{HttpFp::to_uri.(req).to_s}' #{req[:header].map(&@@header_to_httpie).join(" ")}}
    if req[:body] && !req[:body].empty?
      %{echo $'#{req[:body].gsub("'", "\'")}' |\\\n#{first_part}}
    else
      first_part
    end
  }
  @@header_to_httpie = -> a {
    "\\\n    '#{a[0]}: #{a[1]}'"
  }
end
