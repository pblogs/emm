module SanitizeDescription
  extend ActiveSupport::Concern
  require 'sanitize'
  require 'sanitize_config'

  included do
    # Callbacks
    before_save :sanitize_description
  end

  private

  def sanitize_description
    self.description = Sanitize.fragment(description, Sanitize::Config::CUSTOM)
  end
end
