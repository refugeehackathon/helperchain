#
# This is a simple class to send SMSes through urlstring.sms.netzquadrat.de.
#
# Usage:
#
# # configure first, only once:
# Netzquadrat::SmsSender.config = { ... }
# see REQUIRED_CONFIG_KEYS for what's required.
#
# # then send your SMSes:
# Netzquadrat::SmsSender.send_sms("0173424241", "Hello World!")
# Netzquadrat::SmsSender.send_sms("0173424242", "Hello World 2!")
# # [...]
#
# See this file for the gateways documention:
# http://urlstring.sms.netzquadrat.de/docu/index.php?show=konventionen
#
#
module Netzquadrat

  class SmsSender

    # this defines a module accessor. 
    # be aware that this variable stays the same for as long as the process runs, or the variable
    # is set again.
    mattr_accessor :config

    REQUIRED_CONFIG_KEYS = [:script_name, :account, :password, :script_version, :sender_nr]

    # use a custom exception class, rescue with "rescue Netzquadrat::SmsSender::Error"
    class Error < StandardError; end

    def self.send_sms(phone_nr, message)
      new.send_sms(phone_nr, message)
    end

    def send_sms(phone_nr, message)
      validate!(phone_nr, message)
      url = build_url(phone_nr, message)
      result = do_request(url)
      if result == "Success: SMS delivered"
        true
      else
        raise Error, "Failed to deliver SMS; #{result}"
      end

    end

    def build_url(phone_nr, message)
      params = {
        ver:     config[:script_version],
        account: config[:account],
        passwd:  config[:password],
        number:  phone_nr,
        # the SMS gateway wasn't able to display umlauts (ÄÖÜ) correctly in the SMS, so I'm replacing them.
        message: transliterate_german_umlauts(message),
        # I am submitting the (currently invalid) sender nr to the SMS service because if I don't do that
        # a different one will be used for every SMS, which may confuse the helpers. Later on, the project
        # manager may be able to add his mobile number, so he will become the sender and can be contacted 
        # directly.
        oadc:    config[:sender_nr]
      }
      config[:script_name] + "?" + params.to_query
    end

      private

      def validate!(phone_nr, message)
        if REQUIRED_CONFIG_KEYS.any? { |key| !config.has_key?(key) }
          raise Error, "configuration is incomplete: #{config.inspect}"
        end
        if !config || config.empty? || config.any? { |key, value| value.empty? }
          raise Error, "configuration is incomplete: #{config.inspect}"
        end
        if phone_nr.blank? || message.blank?
          raise Error, "phone_nr and message are required parameters."
        end
      end

      # this is in a separate method so testing (stubbing/mocking) of the remote call is easier.
      def do_request(url)
        uri = URI(url) # Net::HTTP wants an URI object rather than a string :-/
        Net::HTTP.get(uri)
      end

      # I am keeping transliteration very basic here on purpose ... to be extended on demand.
      def transliterate_german_umlauts(string)
        map = {
          'Ä' => 'Ae', 'ä' => 'ae', 'Ö' => 'Oe', 'ö' => 'oe', 'Ü' => 'ue', 'ü' => 'ue', 'ß' => 'ss', 
        }
        map.each { |from, to| string = string.gsub(from, to) }
        string
      end
  end
end