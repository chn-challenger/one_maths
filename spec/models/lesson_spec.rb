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

  xdescribe '#random' do
    context 'there are questions to select from' do
      let!(:maker){create_maker}
      let!(:course){create_course(maker)}
      let!(:unit){create_unit(course,maker)}
      let!(:topic){create_topic(unit,maker)}
      let!(:lesson){create_lesson(topic,maker)}
      let!(:question_1){create_question(maker,1)}
      let!(:question_2){create_question(maker,2)}

      it 'randomly selects question 1' do
        lesson.questions = [question_1,question_2]
        lesson.save
        srand(100)
        random_question = lesson.random
        expect(random_question.question_text).to eq "question text 1"
        expect(random_question.solution).to eq "solution 1"
      end

      it 'randomly selects question 2' do
        srand(101)
        lesson.questions = [question_1,question_2]
        lesson.save
        random_question = lesson.random
        expect(random_question.question_text).to eq "question text 2"
        expect(random_question.solution).to eq "solution 2"
      end
    end

    context 'there are no questions to select from' do
      let!(:maker){create_maker}
      let!(:course){create_course(maker)}
      let!(:unit){create_unit(course,maker)}
      let!(:topic){create_topic(unit,maker)}
      let!(:lesson){create_lesson(topic,maker)}

      it 'randomly selects question 1' do
        random_question = lesson.random
        expect(random_question).to eq nil
      end
    end
  end
end
