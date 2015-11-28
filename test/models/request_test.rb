require 'test_helper'

class RequestTest < ActiveSupport::TestCase

  # commented out by phillip because fixtures were broken
  # test "correct confirmed helpers" do
  #   r = requests(:drk_req_with_helpers)
  #   assert_equal r.confirmed_helpers, [helpers(:helper_far_away), helpers(:helper_three)]
  # end

  test "timeout returns one tenth of the time of start and end" do
    r = requests(:drk_req_with_helpers)
    now = Time.now
    r.start  = now
    r.end    = now + 1.hour
    expected_timeout = 6
    assert_equal expected_timeout, r.timeout_time
  end

  test "timeout returns 5 minutes when request is really short" do
    r = requests(:drk_req_with_helpers)
    now = Time.now
    r.start  = now
    r.end    = now + 1.second
    expected_timeout = 5
    assert_equal expected_timeout, r.timeout_time
  end


#  test "correct pending helpers" do
#    r = requests(:drk_req_with_helpers)
#    puts r.pending_helpers.to_json
#    assert_equal r.pending_helpers, [helpers(:helper_three)]
#  end
end