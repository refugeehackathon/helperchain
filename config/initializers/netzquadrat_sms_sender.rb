require 'netzquadrat/sms_sender'

Netzquadrat::SmsSender.config = {
  script_name: ENV['SMS_GATEWAY_SCRIPT_NAME'],
  script_version: ENV['SMS_GATEWAY_SCRIPT_VERSION'],
  account: ENV['SMS_GATEWAY_SMS_ACCOUNT'],
  password: ENV['SMS_GATEWAY_PASSWORD'],
  sender_nr: ENV['SMS_GATEWAY_SENDER_NR']
}
