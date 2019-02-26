require "minitest_helper"
require "http_fp"
require "http_fp/rack"
require "http_fp/httpie"

class HttpFp::CurlTest < Minitest::Test
  include HttpFp

  def setup
    @curl = (verb.("GET") >>
             with_path.("/coucou") >>
             with_headers.(json_headers) >>
             with_host.("https://api.github.com") >>
             with_json.({ user: "martin" }) >>
             HttpFp::Httpie.req).(empty_req)
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
