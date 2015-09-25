module FrontendHelper

  def frontend_url(path, options = {})
    uri_params = {scheme: ENV['PROTOCOL'], port: (ENV['PORT'] || 80).to_i, host: ENV['HOST'], path: path}
    uri_params.merge!({query: options.to_query}) if options.present?
    uri = URI::HTTP.build uri_params
    uri.to_s
  end
end
