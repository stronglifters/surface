require "cucumber/rails"
require "capybara/poltergeist"

$flipper.enable(:gym)
ActionController::Base.allow_rescue = false
DatabaseCleaner.strategy = :transaction
Capybara.javascript_driver = :poltergeist
Cucumber::Rails::Database.javascript_strategy = :truncation
Dir[Rails.root.join("spec/support/pages/*.rb")].each { |x| require x }
