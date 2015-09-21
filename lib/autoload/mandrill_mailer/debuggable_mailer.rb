require 'mandrill_mailer/template_mailer'

module MandrillMailer
  class DebuggableMailer < MandrillMailer::TemplateMailer
    def deliver
      if MandrillMailer.config.letter_opener
        temp_file = Tempfile.new([SecureRandom.hex, '.html'])
        temp_file.write ERB.new(letter_template).result(binding)
        temp_file.close
        Launchy.open(temp_file.path)
      else
        super
      end
    end

    protected

    def letter_template
      File.read(File.join(Rails.root, 'app/views/letter_opener', 'mandrill.erb'));
    end
  end
end
