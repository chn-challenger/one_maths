require 'rails_helper'
require 'general_helpers'

describe QuestionsHelper, type: :helper do
  let!(:question_helper) { Class.new { include QuestionsHelper }.new }

  describe '#get_question' do
    it 'fetch Question record from database' do
      question = create_question(1)
      params = {question_id: 1}
      expect(question_helper.get_question(params)).to eq question
    end
  end
end
