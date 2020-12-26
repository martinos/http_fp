require "minitest_helper"
require "http_fn"
require "http_fn/rack"
require "http_fn/httpie"

class HttpFn::CurlTest < Minitest::Test
  include HttpFn

  def setup
    @curl = (verb.("GET") >>
             with_path.("/coucou") >>
             with_headers.(json_headers) >>
             with_host.("https://api.github.com") >>
             with_json.({ user: "martin" }) >>
             HttpFn::Httpie.req).(empty_req)
  end

  def test_should_return_a_curl_command
    res = <<EOF
echo $'{"user":"martin"}' |\\
http GET 'https://api.github.com/coucou?' \\
    'accept: application/json' \\
    'Content-Type: application/json' \\
    'user-agent: paw/3.0.11 (macintosh; os x/10.11.6) gcdhttprequest'
EOF
    assert_equal res.chomp, @curl
  end
end
