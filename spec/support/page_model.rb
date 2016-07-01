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

  def wait_for_ajax
    yield if block_given?
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def login_with(username, password)
    LoginPage.new.tap do |login_page|
      login_page.visit_page
      login_page.login_with(username, password)
    end
  end

  def pretty_print
    Nokogiri::HTML(page.html)
  end

  def record_failure(dir = Rails.root.join("tmp", "screenshots"))
    puts pretty_print
    FileUtils.mkdir_p(dir)
    now = DateTime.now
    path = File.join(dir, "#{now.to_s.parameterize}.png")
    puts "saving screenshot to: #{path}"
    page.save_screenshot(path, full: true)
  rescue => error
    puts error.inspect
  end

  private

  def translate(key)
    I18n.translate(key)
  end

  def finished_all_ajax_requests?
    page.evaluate_script("jQuery.active").zero?
  end
end
