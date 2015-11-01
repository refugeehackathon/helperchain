require 'test_helper'

class RequestMailerTest < ActionMailer::TestCase
  test "no_more_helpers" do
    mail = RequestMailer.no_more_helpers
    assert_equal "No more helpers", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "request_done" do
    mail = RequestMailer.request_done
    assert_equal "Request done", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "helper_request" do
    mail = RequestMailer.helper_request
    assert_equal "Helper request", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
