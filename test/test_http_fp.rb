require 'minitest_helper'

class TestHttpFp < MiniTest::Unit::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::HttpFp::VERSION
  end
end
