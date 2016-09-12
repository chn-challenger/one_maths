require 'rails_helper'

feature 'static pages' do
  context 'Home page' do
    scenario 'can navigate to homepage' do
      visit '/'
      click_link 'OneMaths'
      expect(current_path).to eq '/'
    end
  end

  context 'About page' do
    scenario 'can navigate to About' do
      visit '/'
      first(:link, 'About').click
      expect(current_path).to eq '/about'
    end
  end

  context 'FAQ page' do
    scenario 'can navigate to FAQ' do
      visit '/'
      first(:link, 'FAQ').click
      expect(current_path).to eq '/faq'
    end
  end

  context 'Contact page' do
    scenario 'can navigate to Contact' do
      visit '/'
      first(:link, 'Contact').click
      expect(current_path).to eq '/contact'
    end
  end
end
