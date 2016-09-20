require 'rails_helper'
require 'general_helpers'

describe User, type: :model do
  describe '#has_current_question?' do
    let!(:course) { create_course  }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }
    let!(:lesson) { create_lesson topic }
    let!(:admin)  { create_admin   }
    let!(:student){ create_student }
    let!(:question_1){create_question(1)}
    let!(:question_2){create_question(2)}
    let!(:question_3){create_question(3)}

    it 'recognize a student have a current question' do
      CurrentQuestion.create(user_id: student.id,
        lesson_id: lesson.id, question_id: question_1.id )
      expect(student.has_current_question?(lesson)).to eq true
    end

    it 'recognize a student do not have a current question' do
      expect(student.has_current_question?(lesson)).to eq false
    end

    # it 'raises error if a student has more than 1 current question for a lesson' do
    #   CurrentQuestion.create(user_id: student.id,
    #     lesson_id: lesson.id, question_id: question_1.id )
    #   CurrentQuestion.create(user_id: student.id,
    #     lesson_id: lesson.id, question_id: question_2.id )
    #   expect{student.has_current_question?(lesson)}.to raise_error 'has more than 1 current question'
    # end
  end

  describe '#fetch_current_question' do
    let!(:course) { create_course  }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }
    let!(:lesson) { create_lesson topic }
    let!(:admin)  { create_admin   }
    let!(:student){ create_student }
    let!(:question_1){create_question(1)}
    let!(:question_2){create_question(2)}
    let!(:question_3){create_question(3)}

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

  describe '#has_current_topic_question?' do
    let!(:course) { create_course  }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }
    let!(:topic_2)  { create_topic unit }
    let!(:lesson) { create_lesson topic }
    let!(:admin)  { create_admin   }
    let!(:student){ create_student }
    let!(:question_1){create_question(1)}
    let!(:question_2){create_question(2)}
    let!(:question_3){create_question(3)}

    it 'recognize a student have a current topic question' do
      CurrentTopicQuestion.create(user_id: student.id,
        topic_id: topic.id, question_id: question_1.id )
      expect(student.has_current_topic_question?(topic)).to eq true
    end

    it 'return false if topic id do not match' do
      CurrentTopicQuestion.create(user_id: student.id,
        topic_id: topic_2.id, question_id: question_1.id )
      expect(student.has_current_topic_question?(topic)).to eq false
    end

    it 'return false if student id do not match' do
      CurrentTopicQuestion.create(user_id: admin.id,
        topic_id: topic.id, question_id: question_1.id )
      expect(student.has_current_topic_question?(topic)).to eq false
    end

    it 'return false when nothing matches' do
      expect(student.has_current_topic_question?(topic)).to eq false
    end
  end

  describe '#fetch_current_topic_question' do
    let!(:course) { create_course  }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }
    let!(:lesson) { create_lesson topic }
    let!(:admin)  { create_admin   }
    let!(:student){ create_student }
    let!(:question_1){create_question(1)}
    let!(:question_2){create_question(2)}
    let!(:question_3){create_question(3)}

    it 'fetches the current topic question of the student for the topic' do
      CurrentTopicQuestion.create(user_id: student.id,
        topic_id: topic.id, question_id: question_1.id )
      expect(student.fetch_current_topic_question(topic)).to eq question_1
    end

    it 'return nil if the student does not have a current topic question' do
      expect(student.fetch_current_topic_question(topic)).to eq nil
    end
  end

end
