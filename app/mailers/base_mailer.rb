class BaseMailer < MandrillMailer::DebuggableMailer
  include FrontendHelper
  default from: ENV['EMAIL_SENDER_EMAIL'], from_name: ENV['EMAIL_SENDER_NAME']

  private

  def mandrill_mail(args)
    args[:vars] ||= {}
    args[:vars][:root_url] = frontend_url('/')
    args[:merge_language] = 'handlebars'
    super(args)
  end
end
