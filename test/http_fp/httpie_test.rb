require 'minitest_helper'
require 'http_fp'
require 'http_fp/rack'
require 'http_fp/httpie'

class HttpFp::CurlTest < Minitest::Test
  include HttpFp

  def setup 
    @curl = verb.("GET") >>~ 
      with_path.("/coucou") >>~ 
      with_headers.(json_headers) >>~ 
      with_host.("https://api.github.com") >>~ 
      with_json.({user: "martin"}) >>~
      HttpFp::Httpie.req >>+ run_
  end

  def test_should_return_a_curl_command
    res = <<EOF
http --json GET 'https://api.github.com/coucou?' \\
    'accept: application/json' \\
    'Content-Type: application/json' \\
    'user-agent: paw/3.0.11 (macintosh; os x/10.11.6) gcdhttprequest' \\
    $'{"user":"martin"}'
EOF
    assert_equal res.chomp, @curl
  end

# http --json POST 'https://app.btrfly.net/api/airports/SFO/newsfeed' \
#     'Accept':'application/json' \
#     'X-API-TOKEN':'KxwCwwZisRisjaNjkQzirnRsypxZDzWs_w' \
#     'Content-Type':'application/json; charset=utf-8' \
#     'X-API-EMAIL':'patrick.lafleur@creationobjet.com' \
#     newsfeed_thread:="{
#   \"title\": \"Qdqfqdsfqdsfqsdfsd fieffés \",
#   \"mentions\": []
# }"

end
