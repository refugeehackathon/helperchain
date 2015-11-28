require 'test_helper'
require 'netzquadrat/sms_sender'

module Netzquadrat
  class SmsSenderTest < ActiveSupport::TestCase

    setup do
      @message  = "Hello Älgar!"
      @phone_nr = "+491794711"
      Netzquadrat::SmsSender.config = {
        # if you want to test locally, install netcat and run it with "nc -l -p 3001"
        script_name: "http://localhost:3001",
        account: "ACCOUNT",
        password: "PASSWORD",
        script_version: "VERSION",
        sender_nr: "SENDER_NR"
      }
    end

    test "config must be given" do
      Netzquadrat::SmsSender.config = nil
      assert_raise { Netzquadrat::SmsSender.send_sms(@phone_nr, @message) }
      Netzquadrat::SmsSender.config = {}
      assert_raise { Netzquadrat::SmsSender.send_sms(@phone_nr, @message) }
      Netzquadrat::SmsSender.config = {script_name: "bla", account: "bla", password: "bla"}
      assert_raise { Netzquadrat::SmsSender.send_sms(@phone_nr, @message) }
      Netzquadrat::SmsSender.config = {script_name: "bla", account: "bla", password: "bla", script_version: "2.0", sender_nr: ""}
      assert_raise { Netzquadrat::SmsSender.send_sms(@phone_nr, @message) }
    end

    test "#build_url works, including URI-escaping the message and phone number" do
      expected = "http://localhost:3001?account=ACCOUNT&message=Hello+Aelgar%21&number=%2B491794711&oadc=SENDER_NR&passwd=PASSWORD&ver=VERSION"
      assert_equal expected, Netzquadrat::SmsSender.new.build_url(@phone_nr, @message)
    end

    test "#send_sms raises an exception if arguments are empty" do
      assert_raise { Netzquadrat::SmsSender.send_sms(nil, @message) }
      assert_raise { Netzquadrat::SmsSender.send_sms(@phone_nr, nil) }
      assert_raise { Netzquadrat::SmsSender.send_sms(nil, nil) }
    end

    test "#send_sms works" do
      Netzquadrat::SmsSender.any_instance.expects(:do_request).once.returns("Success: SMS delivered")
      Netzquadrat::SmsSender.send_sms(@phone_nr, @message)
    end

    test "#send_sms raises a custom exception when there's an error with the gateway" do
      Netzquadrat::SmsSender.any_instance.expects(:do_request).once.returns("Err(19): Net unknown/unavailable")
      assert_raise { Netzquadrat::SmsSender.send_sms(@phone_nr, @message) }
    end

  end
end
