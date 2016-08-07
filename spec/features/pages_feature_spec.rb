require 'rails_helper'

feature 'static pages' do
  context 'Home page' do
    scenario 'can navigate to homepage' do
      visit '/'
      click_link 'Home'
      expect(current_path).to eq '/'
      expect(page).to have_link 'Home'
      expect(page).to have_link 'About'
      # expect(page).to have_link 'FAQ'
      # expect(page).to have_link 'Blog'
      # expect(page).to have_link 'Contact'
    end
  end

  context 'About page' do

  end

  context 'FAQ page' do

  end

  context 'Blog page' do

  end

  context 'Contact page' do

  end
end
