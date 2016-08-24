require 'rails_helper'
require 'general_helpers'

describe Lesson, type: :model do
  describe '#has_current_question?' do
    let!(:course) { create_course  }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }
    let!(:lesson) { create_lesson topic }
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

    it 'recognize a student have a current question' do
      CurrentQuestion.create(user_id: student.id,
        lesson_id: lesson.id, question_id: question_1.id )
      expect(student.has_current_question?(lesson)).to eq true
    end

    it 'recognize a student do not have a current question' do
      expect(student.has_current_question?(lesson)).to eq false
    end

    it 'raises error if a student has more than 1 current question for a lesson' do
      CurrentQuestion.create(user_id: student.id,
        lesson_id: lesson.id, question_id: question_1.id )
      CurrentQuestion.create(user_id: student.id,
        lesson_id: lesson.id, question_id: question_2.id )
      expect{student.has_current_question?(lesson)}.to raise_error 'has more than 1 current question'
    end
  end

  describe '#fetch_current_question' do
    let!(:course) { create_course  }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }
    let!(:lesson) { create_lesson topic }
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

    it 'fetches the current question of the student for lesson' do
      CurrentQuestion.create(user_id: student.id,
        lesson_id: lesson.id, question_id: question_1.id )
      expect(student.fetch_current_question(lesson)).to eq question_1
    end

    it 'return nil if the student does not have a current question' do
      CurrentQuestion.create(user_id: student.id,
        lesson_id: lesson.id)
      expect(student.fetch_current_question(lesson)).to eq nil
    end
  end

  describe '#random_question' do
    let!(:course) { create_course  }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }
    let!(:lesson) { create_lesson topic }
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

    it 'picks a question from the remaining list of unanswered questions' do
      lesson.questions << question_1
      lesson.questions << question_2
      lesson.questions << question_3
      lesson.save
      AnsweredQuestion.create(user_id:student.id, question_id: question_1.id, correct: false)
      srand(100)
      expect(lesson.random_question(student)).to eq question_2
      srand(101)
      expect(lesson.random_question(student)).to eq question_3
    end
  end
end
