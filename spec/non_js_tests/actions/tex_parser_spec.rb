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

    it "adds new questions with answers and their types" do
      parser_with_file = parser.new(tex_file)
      parser_with_file.convert
      expect( Answer.where(answer_type: 'inequality').size ).to eq 2
      expect( Answer.where(answer_type: 'coordinates').size ).to eq 1
      expect( Answer.where(answer_type: 'words').size ).to eq 2
      expect( Answer.where(answer_type: 'normal').size ).to eq 31
    end

    it "adds new questions with tags" do
      parser_with_file = parser.new(tex_file)
      expect(Tag.all.length).to eq 0
      expect { parser_with_file.convert }.to change{ Tag.count }.by(5)
    end

    it "does not add questions, choices and answers records" do
      parser_with_file = parser.new(tex_lessons_file)
      expect { parser_with_file }.not_to change{ Question.count }
      expect { parser_with_file.convert }.not_to change{ Choice.count }
      expect { parser_with_file.convert }.not_to change{ Answer.count }
    end
  end

end
