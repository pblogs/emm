class Sanitize
  module Config
    CUSTOM = freeze_config(
      elements: %w[b em i strong u strike ol ul li p br],
      attributes: {
         all: %w[class dir hidden id lang tabindex title translate],
      })
  end
end
