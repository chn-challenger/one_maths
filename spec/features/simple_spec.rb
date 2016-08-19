require 'spec_helper'
require 'rails_helper'
require 'general_helpers'
require 'capybara/poltergeist'
include Capybara::DSL
Capybara.javascript_driver = :poltergeist

describe 'some stuff which requires js', :js => true do
  it 'will take a screenshot' do  #working
    visit("http://google.com")
    page.driver.render('./file.png', :full => true)
  end
end
