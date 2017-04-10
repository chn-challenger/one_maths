feature 'static pages' do
  context 'About page' do
    scenario 'can navigate to About' do
      visit courses_path
      first(:link, 'About').click
      expect(current_path).to eq '/about'
    end
  end

  context 'FAQ page' do
    scenario 'can navigate to FAQ' do
      visit courses_path
      first(:link, 'FAQ').click
      expect(current_path).to eq '/faq'
    end
  end

  context 'Contact page' do
    scenario 'can navigate to Contact' do
      visit courses_path
      first(:link, 'Contact').click
      expect(current_path).to eq '/contact'
    end
  end

  context 'Question list' do
    let!(:course) { create_course  }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }
    let!(:lesson) { create_lesson topic, 1, 'Published' }
    let!(:admin)  { create_admin   }
    let!(:student){ create_student }
    let!(:question_1){create_question(1)}
    let!(:choice_1){create_choice(question_1,1,false)}
    let!(:choice_2){create_choice(question_1,2,true)}
    let!(:question_2){create_question(2)}
    let!(:choice_3){create_choice(question_2,3,false)}
    let!(:choice_4){create_choice(question_2,4,true)}
    let!(:question_3){create_question(3)}
    let!(:choice_5){create_choice(question_3,5,false)}
    let!(:choice_6){create_choice(question_3,6,true)}

    let!(:question_4){create_question(4)}
    let!(:answer_1){create_answer(question_4,1)}
    let!(:answer_2){create_answer(question_4,2)}
    let!(:question_5){create_question(5)}
    let!(:answer_3){create_answer(question_5,3)}

    scenario 'give list of questions in latex document' do
      lesson.questions = [question_1,question_2,question_3,question_4,question_5]
      lesson.save
      sign_in admin
      visit courses_path
      click_link 'Questions'
      click_link 'Download Questions List'
      expect(current_path).to eq '/download'
    end
  end
end
