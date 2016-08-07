require 'rails_helper'

feature 'static pages' do
  context 'Home page' do
    scenario 'can navigate to homepage' do
      visit '/'
      click_link 'Home'
      expect(current_path).to eq '/'
      expect(page).to have_link 'Home'
      expect(page).to have_link 'About'
      expect(page).to have_link 'FAQ'
      expect(page).to have_link 'Blog'
      expect(page).to have_link 'Contact'
    end
  end

  context 'About page' do
    scenario 'can navigate to About' do
      visit '/'
      click_link 'About'
      expect(page).to have_content 'OneMaths is ...'
      expect(current_path).to eq '/about'
      expect(page).to have_link 'Home'
      expect(page).to have_link 'About'
      expect(page).to have_link 'FAQ'
      expect(page).to have_link 'Blog'
      expect(page).to have_link 'Contact'
    end
  end

  context 'FAQ page' do
    scenario 'can navigate to FAQ' do
      visit '/'
      click_link 'FAQ'
      expect(page).to have_content 'Frequently asked questions'
      expect(current_path).to eq '/faq'
      expect(page).to have_link 'Home'
      expect(page).to have_link 'About'
      expect(page).to have_link 'FAQ'
      expect(page).to have_link 'Blog'
      expect(page).to have_link 'Contact'
    end
  end

  context 'Blog page' do
    scenario 'can navigate to Blog' do
      visit '/'
      click_link 'Blog'
      expect(page).to have_content 'Blogging'
      expect(current_path).to eq '/blog'
      expect(page).to have_link 'Home'
      expect(page).to have_link 'About'
      expect(page).to have_link 'FAQ'
      expect(page).to have_link 'Blog'
      expect(page).to have_link 'Contact'
    end
  end

  context 'Contact page' do
    scenario 'can navigate to Contact' do
      visit '/'
      click_link 'Contact'
      expect(page).to have_content 'Contacting us'
      expect(current_path).to eq '/contact'
      expect(page).to have_link 'Home'
      expect(page).to have_link 'About'
      expect(page).to have_link 'FAQ'
      expect(page).to have_link 'Blog'
      expect(page).to have_link 'Contact'
    end
  end
end
