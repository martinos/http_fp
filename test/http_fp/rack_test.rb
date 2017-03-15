require 'minitest_helper'
require 'http_fp/rack'

# https://github.com/macournoyer/thin/blob/a7d1174f47a4491a15b505407c0501cdc8d8d12c/spec/request/parser_spec.rb
# rack sample
# https://gist.github.com/a1869ea2e5db0563d5772b2eff74ff9f
class HttpFp::RackTest < MiniTest::Test
  include HttpFp

  def setup
    @req = HttpFp.empty_req >>+ with_host.("http://localhost:3000")
  end

  def test_upcase_headers
    req = @req >>+ add_headers.("X-invisible" => "tata")
    env = Rack.to_env.(req)
    assert_equal "tata",  env["HTTP_X_INVISIBLE"]
  end

  def test_basic_headers
    env = verb.("get") >>+ 
           with_host.("https://localhost:3000") >>+ 
            with_query.({"name" => "martin"}) >>+
            with_path.("/users/1") >>+ 
            Rack.to_env
    assert_equal "HTTP/1.1", env["SERVER_PROTOCOL"]
    assert_equal "HTTP/1.1", env["HTTP_VERSION"]
    assert_equal "/users/1", env["REQUEST_PATH"]
    assert_equal "GET", env["REQUEST_METHOD"]
    assert_equal 'https', env["rack.url_scheme"]
    assert_equal '/users/1', env["PATH_INFO"]
  end

  def test_host
    env = verb.("get") >>+ 
           with_host.("https://localhost:3000") >>+ 
            with_query.({"name" => "martin"}) >>+
            with_path.("/users/1") >>+ 
            Rack.to_env
    assert_equal "localhost:3000", env["HTTP_HOST"]
    assert_equal "localhost", env["SERVER_NAME"]
    assert_equal "3000", env["SERVER_PORT"]
    assert_equal "name=martin", env["QUERY_STRING"]
    assert_equal "", env["SCRIPT_NAME"]
  end

  def test_dont_prepend_HTTP_to_content_type_and_content_length
    env = verb.("get") >>+ 
           with_host.("https://localhost:3000") >>+ 
            with_query.({"name" => "martin"}) >>+
            with_path.("/users/1") >>+ 
            add_headers.({"content-type" => "application/json", 
                          "content-length" => "12"}) >>+ 
            Rack.to_env
    assert_equal "application/json", env["CONTENT_TYPE"]
    assert_equal "12", env["CONTENT_LENGTH"]
  end
end

