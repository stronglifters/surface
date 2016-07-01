require "cucumber/rails"
require "capybara/poltergeist"

$flipper.enable(:gym)
ActionController::Base.allow_rescue = false
DatabaseCleaner.strategy = :transaction
Capybara.javascript_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end
Cucumber::Rails::Database.javascript_strategy = :truncation
Dir[Rails.root.join("spec/support/pages/*.rb")].each { |x| require x }
