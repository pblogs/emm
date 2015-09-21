MandrillMailer.configure do |config|
  config.api_key = ENV['MANDRILL_API_KEY']
  config.default_url_options = { host: ENV['HOST'], port: ENV['PORT'] || 80 }
end
