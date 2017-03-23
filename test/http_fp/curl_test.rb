require 'minitest_helper'
require 'http_fp'
require 'http_fp/rack'
require 'http_fp/curl'

class HttpFp::CurlTest < Minitest::Test
  include HttpFp

  def setup 
    @curl = verb.("GET") >>~ 
      with_path.("/coucou") >>~ 
      with_headers.(json_headers) >>~ 
      with_host.("https://api.github.com") >>~ 
      with_json.({user: "martin"}) >>~
      to_curl >>+ run_
  end

  def test_should_return_a_curl_command
    res = <<EOF
curl -X 'GET' 'https://api.github.com/coucou?' \\
    -H 'accept: application/json' \\
    -H 'Content-Type: application/json' \\
    -H 'user-agent: paw/3.0.11 (macintosh; os x/10.11.6) gcdhttprequest'
    -d $'{"user":"martin"}'
EOF
    assert_equal res.chomp, @curl
  end
end
