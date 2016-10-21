require 'rails_helper'
require 'general_helpers'


describe TexParser, type: :action do
  let(:parser) { TexParser }
  let(:tex_file) { Rails.root + "spec/fixtures/Questions_Differentiation.tex" }
  let(:tex_lessons_file) { Rails.root + "spec/fixtures/lesson_questions.tex"}

  describe '#convert' do
    it "adds new questions, choices and answers records" do
      parser_with_file = parser.new(tex_file)
      expect { parser_with_file.convert }.to change{ Question.count }
      expect { parser_with_file.convert }.to change{ Choice.count }
      expect { parser_with_file.convert }.to change{ Answer.count }
    end

    it "does not add questions, choices and answers records" do
      parser_with_file = parser.new(tex_lessons_file)
      expect { parser_with_file }.not_to change{ Question.count }
      expect { parser_with_file.convert }.not_to change{ Choice.count }
      expect { parser_with_file.convert }.not_to change{ Answer.count }
    end
  end

end
