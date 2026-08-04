# frozen_string_literal: true

module SimpleColumn
  # This is a Class / Module Hybrid (see simple_column/scopes.rb)
  class Scopes < Module
    # Version namespace for this gem.
    module Version
      # Current gem version.
      VERSION = "0.1.1"
    end
    # Current gem version exposed at the traditional constant location.
    VERSION = Version::VERSION # Traditional Constant Location
  end
end
