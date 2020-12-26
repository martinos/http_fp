require "net/http"
require "http_fn"

module HttpFn::Curl
  include HttpFn

  fn_reader :print_curl, :req

  @@req = -> req {
    first_part = %{curl -X '#{req[:method]}' '#{HttpFn::to_uri.(req).to_s}' #{req[:header].map(&@@header_to_curl).join(" ")}}
    if req[:body] && !req[:body].empty?
      first_part + %{\n\    -d $'#{req[:body].gsub("'", "\'")}'}
    else
      first_part
    end
  }
  @@header_to_curl = -> a {
    "\\\n    -H '#{a[0]}: #{a[1]}'"
  }

  @@print_curl = -> req { $stdout.puts(to_curl.(req)); req }.curry
end
