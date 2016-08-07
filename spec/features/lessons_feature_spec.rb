require 'rails_helper'

def sign_up_tester
  visit('/')
  click_link('Sign up')
  fill_in('Email', with: 'tester@example.com')
  fill_in('Password', with: 'testtest')
  fill_in('Password confirmation', with: 'testtest')
  click_button('Sign up')
  visit "/courses"
end

def sign_in_maker
  visit '/'
  click_link 'Sign in'
  fill_in 'Email', with: 'maker@maker.com'
  fill_in 'Password', with: '12344321'
  click_button 'Log in'
  visit '/'
end

def create_maker
  maker = Maker.create(email: 'maker@maker.com', password: '12344321',
    password_confirmation: '12344321')
end

def create_course(maker)
  maker.courses.create(name:'Science',description:'Super fun!')
end

def create_unit(course,maker)
  course.units.create_with_maker({name:'Core 1', description:'Basic maths'},maker)
end

def create_topic(unit,maker)
  unit.topics.create_with_maker({name:'Indices', description:'blank for now'},maker)
end

def create_lesson(topic,maker)
  topic.lessons.create_with_maker({name:'Index multiplication',
    description:'times divide power again of indices',video:"0QjF6A3Zwkk"},
    maker)
end

feature 'lessons' do
  context 'A course unit with no topics' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}

    scenario 'should display a prompt to add a lesson' do
      sign_in_maker
      expect(current_path).to eq '/'
      expect(page).to have_content 'No lessons have been added to Indices'
      expect(page).to have_link 'Add a lesson to Indices'
    end
  end

  context 'adding lessons' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}

    scenario 'when not logged in cannot add a lesson' do
      visit "/"
      expect(page).not_to have_link "Add a lesson to Indices"
    end

    scenario 'a maker adding a lesson to his topic' do
      sign_in_maker
      click_link 'Add a lesson to Indices'
      fill_in 'Name', with: 'Index multiplication'
      fill_in 'Description', with: 'times divide power again of indices'
      fill_in 'Video', with: "0QjF6A3Zwkk"
      click_button 'Create Lesson'
      expect(page).to have_content 'Index multiplication'
      expect(page).to have_content 'times divide power again of indices'
      expect(current_path).to eq '/'
    end

    scenario 'a different maker cannot add a lesson' do
      sign_up_tester
      visit "/topics/#{topic.id}/lessons/new"
      expect(page).not_to have_link "Add a lesson to Indices"
      expect(page).to have_content 'You can only add lessons to your own topics'
      expect(current_path).to eq '/'
    end
  end

  context 'viewing lessons' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}
    let!(:lesson){create_lesson(topic,maker)}

    scenario 'view the details of a lesson' do
      visit "/"
      click_link 'View Index multiplication'
      expect(page).to have_content 'Index multiplication'
      expect(page).to have_content 'times divide power again of indices'
      expect(current_path).to eq "/lessons/#{lesson.id}"
    end
  end

  context 'updating lessons' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}
    let!(:lesson){create_lesson(topic,maker)}

    scenario 'a maker can update his own lessons' do
      sign_in_maker
      click_link 'Edit Index multiplication'
      fill_in 'Name', with: 'A lesson'
      fill_in 'Description', with: 'basic lesson'
      fill_in 'Video', with: 'QiI9exfA'
      click_button 'Update Lesson'
      expect(page).to have_content 'A lesson'
      expect(page).to have_content 'basic lesson'
      expect(current_path).to eq '/'
    end

    scenario "a maker cannot edit someone else's lessons" do
      sign_up_tester
      visit "/lessons/#{lesson.id}/edit"
      expect(page).not_to have_link 'Edit Index multiplication'
      expect(page).to have_content 'You can only edit your own lessons'
      expect(current_path).to eq "/"
    end
  end

  context 'deleting lessons' do
    let!(:maker){create_maker}
    let!(:course){create_course(maker)}
    let!(:unit){create_unit(course,maker)}
    let!(:topic){create_topic(unit,maker)}
    let!(:lesson){create_lesson(topic,maker)}

    scenario 'a maker can delete their own lessons' do
      sign_in_maker
      click_link 'Delete Index multiplication'
      expect(page).not_to have_content 'Index multiplication'
      expect(page).not_to have_content 'times divide power again of indices'
      expect(current_path).to eq "/"
    end

    scenario "a maker cannot delete another maker's lessons" do
      sign_up_tester
      visit '/'
      expect(page).not_to have_link 'Delete Index multiplication'
      page.driver.submit :delete, "/lessons/#{lesson.id}",{}
      expect(page).to have_content 'Can only delete your own lessons'
    end
  end

end
