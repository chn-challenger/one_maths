describe Ability, type: :model do
  describe 'teacher' do
    let!(:teacher) { create_teacher }
    let!(:student) { create_student }
    let!(:course) { create_course('Private', :private, teacher.id) }
    let!(:unit)   { create_unit course }
    let!(:topic)  { create_topic unit }
    let!(:lesson) { create_lesson topic, 1, 'Published' }
    let!(:question) { create_question 2, nil, teacher.id }
    let!(:admin) { create_admin }
    let!(:course_p) { create_course }
    let!(:unit_p)   { create_unit course_p }
    let!(:topic_p)  { create_topic unit_p }
    let!(:lesson_p) { create_lesson topic_p, "", 'Published' }
    let!(:question_p) { create_question 1 }
    let!(:ability) { Ability.new(teacher) }

    it "can't edit not owned course" do
      expect(ability).not_to be_able_to(:delete, course_p)
    end

    it "can't edit not owned unit" do
      expect(ability).not_to be_able_to(:delete, unit_p)
    end

    it "can't edit not owned topic" do
      expect(ability).not_to be_able_to(:delete, topic_p)
    end

    it "can't edit not owned lesson" do
      expect(ability).not_to be_able_to(:delete, lesson_p)
    end

    it "can't edit not owned question" do
      expect(ability).not_to be_able_to(:delete, question_p)
    end

    it "can edit own course" do
      response = ability.can?(:delete, course)
      expect(response).to be true
    end

    it "can edit own unit" do
      expect(ability).to be_able_to(:delete, unit)
    end

    it "can edit own topic" do
      expect(ability).to be_able_to(:delete, topic)
    end

    it "can edit own lesson" do
      expect(ability).to be_able_to(:delete, lesson)
    end

    it "can edit own question" do
      expect(ability).to be_able_to(:delete, question)
    end
  end
end
