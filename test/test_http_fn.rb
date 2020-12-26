require 'minitest_helper'

class TestHttpFn < MiniTest::Unit::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::HttpFn::VERSION
  end
end
