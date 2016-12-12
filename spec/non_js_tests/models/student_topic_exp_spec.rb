require 'rails_helper'


describe StudentTopicExp, type: :model do
  describe '#self.current_exp' do
    let!(:course) { create_course  }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }
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

  describe '#self.current_level' do
    let!(:course) { create_course  }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }
    let!(:lesson) { create_lesson topic, 1, 'Published' }
    let!(:student){ create_student }

    it 'get defeult current level is 0' do
      expect(StudentTopicExp.current_level(nil,topic)).to eq 0
    end

    it 'returns level 0 at the start of a new topic' do
      expect(StudentTopicExp.current_level(student,topic)).to eq 0
    end

    it 'returns level 1 when there is just enough exp for level 1' do
      student_topic_exp = create_student_topic_exp(student,topic,1000)
      expect(StudentTopicExp.current_level(student,topic)).to eq 1
    end

    it 'returns level 3 correctly' do
      student_topic_exp = create_student_topic_exp(student,topic,8000)
      expect(StudentTopicExp.current_level(student,topic)).to eq 3
    end
  end

  describe '#self.next_level_exp' do
    let!(:course) { create_course }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }
    let!(:lesson) { create_lesson topic, 1, 'Published' }
    let!(:student){ create_student }

    it 'the default next level exp is topic level one exp' do
      expect(StudentTopicExp.next_level_exp(nil,topic)).to eq 1000
    end

    it 'returns exp needed for next level when next level is level 1' do
      student_topic_exp = create_student_topic_exp(student,topic,0)
      expect(StudentTopicExp.next_level_exp(student,topic)).to eq 1000
    end

    it 'returns exp needed for next level when next level is level 2' do
      student_topic_exp = create_student_topic_exp(student,topic,1500)
      expect(StudentTopicExp.next_level_exp(student,topic)).to eq 2000
    end

    it 'returns exp needed for next level when next level is level 3' do
      student_topic_exp = create_student_topic_exp(student,topic,3000)
      expect(StudentTopicExp.next_level_exp(student,topic)).to eq 4000
    end
  end

  describe '#self.current_level_exp' do
    let!(:course) { create_course  }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }
    let!(:lesson) { create_lesson topic, 1, 'Published' }
    let!(:student){ create_student }

    it 'the default current level exp is 0' do
      expect(StudentTopicExp.current_level_exp(nil,topic)).to eq 0
    end

    it 'returns the current level exp needed when in a new topic' do
      student_topic_exp = create_student_topic_exp(student,topic,0)
      expect(StudentTopicExp.current_level_exp(student,topic)).to eq 0
    end

    it 'returns the current level exp needed when eg 1' do
      student_topic_exp = create_student_topic_exp(student,topic,500)
      expect(StudentTopicExp.current_level_exp(student,topic)).to eq 500
    end

    it 'returns the current level exp needed when eg 2' do
      student_topic_exp = create_student_topic_exp(student,topic,2400)
      expect(StudentTopicExp.current_level_exp(student,topic)).to eq 1400
    end
  end

  # describe '#current_level' do
  #   let!(:course) { create_course  }
  #   let!(:unit)   { create_unit course }
  #   let!(:topic)  { create_topic unit }
  #   let!(:lesson) { create_lesson topic }
  #   let!(:student){ create_student }
  #
  #   it 'returns the correct current level when there is no experience' do
  #     student_topic_exp = create_student_topic_exp(student,topic,0)
  #     expect(student_topic_exp.current_level).to eq 0
  #   end
  #
  #   it 'returns level 1 when there is just enough exp for level 1' do
  #     student_topic_exp = create_student_topic_exp(student,topic,1000)
  #     expect(student_topic_exp.current_level).to eq 1
  #   end
  #
  #   it 'returns level 3 correctly' do
  #     student_topic_exp = create_student_topic_exp(student,topic,8000)
  #     expect(student_topic_exp.current_level).to eq 3
  #   end
  # end
  #
  # describe '#next_level_exp' do
  #   let!(:course) { create_course  }
  #   let!(:unit)   { create_unit course }
  #   let!(:topic)  { create_topic unit }
  #   let!(:lesson) { create_lesson topic }
  #   let!(:student){ create_student }
  #
  #   it 'returns exp needed for next level when next level is level 1' do
  #     student_topic_exp = create_student_topic_exp(student,topic,0)
  #     expect(student_topic_exp.next_level_exp).to eq 1000
  #   end
  #
  #   it 'returns exp needed for next level when next level is level 2' do
  #     student_topic_exp = create_student_topic_exp(student,topic,1500)
  #     expect(student_topic_exp.next_level_exp).to eq 2000
  #   end
  #
  #   it 'returns exp needed for next level when next level is level 3' do
  #     student_topic_exp = create_student_topic_exp(student,topic,3000)
  #     expect(student_topic_exp.next_level_exp).to eq 4000
  #   end
  # end
  #
  # describe '#current_level_exp' do
  #   let!(:course) { create_course  }
  #   let!(:unit)   { create_unit course }
  #   let!(:topic)  { create_topic unit }
  #   let!(:lesson) { create_lesson topic }
  #   let!(:student){ create_student }
  #
  #   it 'returns the current level exp needed when in a new topic' do
  #     student_topic_exp = create_student_topic_exp(student,topic,0)
  #     expect(student_topic_exp.current_level_exp).to eq 0
  #   end
  #
  #   it 'returns the current level exp needed when eg 1' do
  #     student_topic_exp = create_student_topic_exp(student,topic,500)
  #     expect(student_topic_exp.current_level_exp).to eq 500
  #   end
  #
  #   it 'returns the current level exp needed when eg 2' do
  #     student_topic_exp = create_student_topic_exp(student,topic,2400)
  #     expect(student_topic_exp.current_level_exp).to eq 1400
  #   end
  # end
end
