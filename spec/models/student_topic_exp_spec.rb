require 'rails_helper'
require 'general_helpers'

describe StudentTopicExp, type: :model do
  describe '#self.current_exp' do
    let!(:course) { create_course  }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }
    # let!(:lesson) { create_lesson topic }
    let!(:student){ create_student }
    let!(:student_topic_exp){ create_student_topic_exp(student,topic,500)}

    it 'get current experience of 0 given unknow student or topic' do
      expect(StudentTopicExp.current_exp(11,12)).to eq 0
    end

    it 'get current experience of 0 given unknow wrong inputs' do
      expect(StudentTopicExp.current_exp(nil,nil)).to eq 0
    end

    it 'get current experience given topic and student' do
      expect(StudentTopicExp.current_exp(student,topic)).to eq 500
    end

    it 'get current experience given topic and student id' do
      expect(StudentTopicExp.current_exp(student.id,topic)).to eq 500
    end

    it 'get current experience given topic id and student' do
      expect(StudentTopicExp.current_exp(student,topic.id)).to eq 500
    end

    it 'get current experience given topic id and student id' do
      expect(StudentTopicExp.current_exp(student.id,topic.id)).to eq 500
    end
  end
end
