require 'rails_helper'
require 'general_helpers'

describe QuestionsHelper, type: :helper do
  let(:dummy_class) { Class.new { include QuestionsHelper } }

  describe '#standardise_answer' do
    it 'standardise answer eg 1' do
      dummy_instance = dummy_class.new
      expect(dummy_instance.standardise_answer("3,2.122")).to eq ['2.12','3.00']
    end

    it 'standardise answer eg 2' do
      dummy_instance = dummy_class.new
      expect(dummy_instance.standardise_answer("3, x 2.125")).to eq ['2.13','3.00']
    end
  end
end
