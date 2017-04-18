describe Course, type: :model do
  let(:course_1) { create_course }
  let(:course_2) { create_course('Private', :private) }
  let(:course_3) { create_course('Private #2', :private) }
  let(:course_4) { create_course('Public #2') }

  describe '#status' do
    it "fetches all courses with status :private" do
      response = [course_2, course_3]
      expect(Course.status(:private)).to eq response
    end

    it 'fetches all courses with status :public' do
      response = [course_1, course_4]
      expect(Course.status(:public)).to eq response
    end
  end
end
