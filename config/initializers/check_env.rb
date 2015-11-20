# coding: utf-8
errors = []
warnings = []

def missing? k
  ENV[k].nil? || ENV[k].empty?
end

# ERRORS

if missing? "HOST"
  errors << "Please set the HOST environment Variable"
elsif Rails.env.production? and ENV["HOST"].starts_with? "localhost"
  warnings << "Your HOST should not be localhost but the host your users are seeing (e.g. example.com)"
end
errors << "Please set the CONTACT_EMAIL environmnent Variable" if missing? "CONTACT_EMAIL"
errors << "Please set the DB_NAME environmnent Variable" if missing? "DB_NAME"
errors << "Please set the REDIS_URL environmnent Variable" if missing? "REDIS_URL"

# Warnings

warnings << "Consider using a Mail delivery service when deploying to production" if missing? "MAILGUN_API_KEY"
warnings << "The admin interface is enabled!" if ENV['ENABLE_ADMIN'] == "TRUE"
warnings << "Consider to set the SIDEKIQ_NAMESPACE!" if missing? "SIDEKIQ_NAMESPACE"
warnings << "Consider setting the TIMEZONE – Otherwise I will use #{Time.now.zone}" if missing? "TIMEZONE"

# Print code

unless warnings.empty?
  print "\e[1;33m"
  warnings.each {|e| puts "* #{e}"}
  puts "\e[0m"
end

if Rails.env.production? and ENV["IGNORE_WARNINGS"] != "TRUE"
  errors << "You are in production and there are some warnings to fix. If you want to ignore them, set IGNORE_WARNINGS to TRUE"
end

unless errors.empty?
  print "\e[01;31m"
  puts "Please read the README and fix the following errors by setting the ENV variable or creating the .env.#{Rails.env} file:"
  print "\e[0m\033[1m"
  errors.each {|e| puts "* #{e}"}
  puts "\e[0m"
  exit(2)
end
