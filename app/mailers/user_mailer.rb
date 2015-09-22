class UserMailer < BaseMailer
  def confirmation_instructions(record, token, opts={})
    mandrill_mail(
      template: 'user-confirmation-instructions',
      subject: 'Confirmation instructions',
      to: opts[:to] || record.email,
      vars: {
          EMAIL: opts[:to] || record.email,
          CONFIRMATION_URL: frontend_url(path: "users/confirm/#{token}")
      }
    )
  end

  def reset_password_instructions(record, token, opts={})
    mandrill_mail(
      template: 'reset-password-instructions',
      subject: 'Reset password instructions',
      to: opts[:to] || record.email,
      vars: {
          RESET_TOKEN: token,
          RESET_URL: frontend_url(path: "recovery/#{token}")
      }
    )
  end

  def unlock_instructions(record, token, opts={})
    mandrill_mail(
      template: 'unlock-instructions',
      subject: 'Unlock instructions',
      to: opts[:to] || record.email,
      vars: {
          RESET_URL: ''
      }
    )
  end
end
