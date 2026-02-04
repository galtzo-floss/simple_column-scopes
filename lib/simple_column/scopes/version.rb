module SimpleColumn
  # This is a Class / Module Hybrid (see simple_column/scopes.rb)
  class Scopes < Module
    module Version
      VERSION = "0.1.1"
    end
    VERSION = Version::VERSION # Traditional version location
  end
end
