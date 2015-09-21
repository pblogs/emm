module FrontendHelper

  def frontend_url(options = {})
    path = options.delete(:path)
    [].tap do |parts|
      parts << "#{ENV['PROTOCOL']}://#{ENV['HOST']}"
      if path.present?
        parts << '/' unless path[0] == '/'
        parts << path
      end
    end.join ''
  end
end
