require 'timeout'

module WaitForAjax

  def click_ajax_link(locator, options = {})
    click_link(locator, options)

    wait_for_ajax
  end

  def wait_for_ajax
    # Timeout.timeout(Capybara.default_max_wait_time) do
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end

RSpec.configure do |config|
  config.include WaitForAjax, type: :feature
end
