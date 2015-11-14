require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  test "correct confirmed helpers" do
    r = requests(:drk_req_with_helpers)
    assert_equal r.confirmed_helpers, [helpers(:helper_far_away), helpers(:helper_three)]
  end
#  test "correct pending helpers" do
#    r = requests(:drk_req_with_helpers)
#    puts r.pending_helpers.to_json
#    assert_equal r.pending_helpers, [helpers(:helper_three)]
#  end
end
