module SanitizeDescription
  extend ActiveSupport::Concern
  require 'sanitize'

  included do
    # Callbacks
    before_save :sanitize_description
  end

  private

  def sanitize_description
    self.description = Sanitize.fragment(description, Sanitize::Config::BASIC)
  end
end
