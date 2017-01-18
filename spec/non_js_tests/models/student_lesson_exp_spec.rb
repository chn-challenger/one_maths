require 'rails_helper'


describe StudentLessonExp, type: :model do
  describe '#self.current_exp' do
    let!(:course) { create_course  }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }
    let!(:lesson) { create_lesson topic, 1, 'Published' }
    let!(:student){ create_student }
    let!(:question_1) { create_question(1, lesson) }
    let!(:student_lesson_exp){ create_student_lesson_exp(student,lesson,100)}

    it 'get current experience of 0 given unknow student or lesson' do
      expect(StudentLessonExp.current_exp(11,12)).to eq 0
    end

    it 'get current experience of 0 given unknow wrong inputs' do
      expect(StudentLessonExp.current_exp(nil,nil)).to eq 0
    end

    it 'get current experience given lesson and student' do
      expect(StudentLessonExp.current_exp(student,lesson)).to eq 100
    end

    it 'get current experience given lesson id and student' do
      expect(StudentLessonExp.current_exp(student,lesson.id)).to eq 100
    end

    it 'get current experience given lesson and student id' do
      expect(StudentLessonExp.current_exp(student.id,lesson)).to eq 100
    end

    it 'get current experience given lesson id and student id' do
      expect(StudentLessonExp.current_exp(student.id,lesson.id)).to eq 100
    end

    it 'give experience as maximum pass' do
      student_2 = create_student
      student_2_lesson_exp = create_student_lesson_exp(student_2,lesson,1500)
      expect(StudentLessonExp.current_exp(student_2.id,lesson.id)).to eq 100
    end
  end
end
