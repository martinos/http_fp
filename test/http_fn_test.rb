require "minitest_helper"
require "http_fn"

class HttpFn::HttpFnTest < Minitest::Test
  include HttpFn

  def test_basic_auth
    req = with_basic_auth.("martin").("secret").(empty_req)
    authorization = req[:header]["Authorization"]
    refute_nil authorization
    assert_equal "Basic bWFydGluOnNlY3JldA==", authorization
  end
end
