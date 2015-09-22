class TestMailer < BaseMailer
  def test_email(data)
    mandrill_mail(
      template: 'test',
      to: data[:email],
      subject: 'This is test email',
      vars: {
        TEST_DATA: data
      }
    )
  end
end
