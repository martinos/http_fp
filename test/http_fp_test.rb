require 'minitest_helper'
require 'http_fp'

class HttpFp::HttpFpTest < Minitest::Test
  include HttpFp

  def test_basic_auth
    req = empty_req >>+ with_basic_auth.("martin").("secret")
    authorization = req[:header]["Authorization"]
    refute_nil authorization
    assert_equal "Basic bWFydGluOnNlY3JldA==", authorization
  end
end

