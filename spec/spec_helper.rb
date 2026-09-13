require "kettle/test/rspec"
# `kettle/test/rspec` installs harness helpers documented in spec/README.md.
RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# Config for development dependencies of this library
# i.e., not configured by this library
#
# Simplecov & related config (must run BEFORE any other requires)
# NOTE: Gemfiles for older rubies won't have kettle-soup-cover.
#       The rescue LoadError handles that scenario.
begin
  require "kettle-soup-cover"
  if Kettle::Soup::Cover::DO_COV
    # Requiring simplecov loads the project-local `.simplecov`.
    require "simplecov"
    require "kettle/soup/cover/config"
    SimpleCov.start
  end
rescue LoadError => error
  # check the error message and re-raise when unexpected
  raise error unless error.message.include?("kettle")
end

require "simple_column/scopes"

# AnonymousActiveRecord connects with the sqlite3 adapter by default. On JRuby,
# activerecord-jdbc-adapter provides that adapter name from ActiveRecord 7.2;
# older ActiveRecord needs the jdbcsqlite3 adapter name.
require "active_record"
require "activerecord-jdbcsqlite3-adapter" if RUBY_PLATFORM == "java"
ANONYMOUS_AR_CONNECTION_PARAMS = {
  adapter: (RUBY_PLATFORM == "java" && ActiveRecord.gem_version < Gem::Version.new("7.2")) ? "jdbcsqlite3" : "sqlite3",
  encoding: "utf8",
  database: ":memory:"
}.freeze
