require 'json'

class TexParser
  PREFIX = "$\\\\$"
  REPLACEMENT = "END"

  def initialize(uploaded_tex_file)
    @uplaoded_tex_file = uploaded_tex_file
    @questions_raw = []
    @data_array = []
    @elements = [
      "question-text",
      "solution-text",
      "question-experience",
      "question-order-group",
      "question-level",
      "choice-text",
      "choice-correct",
      "answer-label",
      "answer-value",
      "answer-hint"
     ]
  end

  def set_questions_array
    @questions_raw = get_tex_file.to_enum(:scan, /question-text\$\\\\\$(.*?)question-text\$\\\\\$/m).map { Regexp.last_match }
  end

  def convert
    set_questions_array
    @questions_raw.each do |match|
      convert_to_json(match)
    end
  end

  def convert_to_json(match)
    match = match.to_s
    @elements.each do |marker|
      match = match.gsub("#{ marker + PREFIX }", marker)
    end
    match = match.gsub(PREFIX, "END")
    converter(match)
  end

  def converter(question)
    storage = JSON.parse(get_data_file)

    if question.match("choice-text")

      choices = question.scan(/#{@elements[5]}(.*?)#{REPLACEMENT}/m).flatten
      validity = question.scan(/#{@elements[6]}(.*?)#{REPLACEMENT}/m).flatten

      choices_array = []

      i = 0

      while i < choices.size do
        choices_array << {
          "choice-text": choices[i],
          "validity": validity[i]
        }
        i += 1
      end

      choices_question = {
        "question-text": question[/#{@elements[0]}(.*?)#{REPLACEMENT}/m, 1],
        "solution-text": question[/#{@elements[1]}(.*?)#{REPLACEMENT}/m, 1],
        "question-experience": question[/#{@elements[2]}(.*?)#{REPLACEMENT}/m, 1],
        "question-order-group": question[/#{@elements[3]}(.*?)#{REPLACEMENT}/m, 1],
        "question-level": question[/#{@elements[4]}(.*?)#{REPLACEMENT}/m, 1],
        "choices": choices_array
      }
      added_data = storage["data"] << choices_question
      File.write('public/data.json', JSON.pretty_generate(storage))
    elsif question.match("answer-label")

      multipart_question = {
        "question-text": question[/#{@elements[0]}(.*?)#{REPLACEMENT}/m, 1],
        "solution-text": question[/#{@elements[1]}(.*?)#{REPLACEMENT}/m, 1],
        "question-experience": question[/#{@elements[2]}(.*?)#{REPLACEMENT}/m, 1],
        "question-order-group": question[/#{@elements[3]}(.*?)#{REPLACEMENT}/m, 1],
        "question-level": question[/#{@elements[4]}(.*?)#{REPLACEMENT}/m, 1],
        "answers": [
          {
            "answer-label": question[/#{@elements[7]}(.*?)#{REPLACEMENT}/m, 1],
            "answer-value": question[/#{@elements[8]}(.*?)#{REPLACEMENT}/m, 1],
            "answer-hint": question[/#{@elements[9]}(.*?)#{REPLACEMENT}/m, 1]
          }
        ]
      }
      added_data = storage["data"] << multipart_question
      File.write('public/data.json', JSON.pretty_generate(storage))
    end
  end

  def get_data_file
    File.read('public/data.json')
  end

  def get_tex_file
    File.read(@uplaoded_tex_file)
  end
end
