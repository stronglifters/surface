class PageModel
  include Capybara::DSL
  include Rails.application.routes.url_helpers
  attr_reader :page_path

  def initialize(page_path)
    @page_path = page_path
  end

  def visit_page
    visit page_path
    self
  end

  def on_page?
    current_path == page_path
  end

  def login_with(username, password)
    LoginPage.new.tap do |login_page|
      login_page.visit_page
      login_page.login_with(username, password)
    end
  end

  private

  def translate(key)
    I18n.translate(key)
  end
end
