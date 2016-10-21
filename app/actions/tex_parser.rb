class TexParser
  PREFIX = "$\\\\$"
  REPLACEMENT = "END"

  def initialize(uploaded_tex_file)
    @uplaoded_tex_file = uploaded_tex_file
    @questions_raw = []
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

  def convert
    set_questions_array
    @questions_raw.each do |match|
      convert_to_json(match)
    end
  end

  private

  def set_questions_array
    @questions_raw = get_tex_file.to_enum(:scan, /question-text\$\\\\\$(.*?)question-text\$\\\\\$/m).map { Regexp.last_match }
  end

  def convert_to_json(match)
    match = match.to_s
    @elements.each do |marker|
      match = match.gsub("#{ marker + PREFIX }", marker)
    end
    match = match.gsub(PREFIX, "END")
    converter(match)
  end

  def tex_sanitizer(tex_string)
    tex_string.gsub(/\A\n/m, "")
  end

  def converter(question)
    puts "********************************"
    puts "********************************"
    puts 'WE ARE HERE'
    puts "********************************"
    puts "********************************"



    question_params = {
      question_text: tex_sanitizer(question[/#{@elements[0]}(.*?)#{REPLACEMENT}/m, 1]),
      solution: tex_sanitizer(question[/#{@elements[1]}(.*?)#{REPLACEMENT}/m, 1]),
      experience: tex_sanitizer(question[/#{@elements[2]}(.*?)#{REPLACEMENT}/m, 1]),
      order: tex_sanitizer(question[/#{@elements[3]}(.*?)#{REPLACEMENT}/m, 1]),
      difficulty_level: tex_sanitizer(question[/#{@elements[4]}(.*?)#{REPLACEMENT}/m, 1])
    }

    new_question = Question.create(question_params)

    if question.match("choice-text")

      choices = question.scan(/#{@elements[5]}(.*?)#{REPLACEMENT}/m).flatten
      validity = question.scan(/#{@elements[6]}(.*?)#{REPLACEMENT}/m).flatten

      i = 0

      while i < choices.size do
        puts "==========================="
        puts "==========================="
        p tex_sanitizer(validity[i])
        puts "==========================="
        puts "==========================="

        new_choice = {
            content: tex_sanitizer(choices[i]),
            correct: tex_sanitizer(validity[i])
        }
        choice_state = new_question.choices.new(new_choice)

        if choice_state.save!
          i += 1
        else
          fail "Choice did not save!"
        end
      end

    elsif question.match("answer-label")

      label = question.scan(/#{@elements[7]}(.*?)#{REPLACEMENT}/m).flatten
      solution = question.scan(/#{@elements[8]}(.*?)#{REPLACEMENT}/m).flatten
      hint = question.scan(/#{@elements[9]}(.*?)#{REPLACEMENT}/m).flatten

      i = 0

      while i < label.size do
        new_multipart_question = {
          label: tex_sanitizer(label[i]),
          solution: tex_sanitizer(solution[i]),
          hint: tex_sanitizer(hint[i])
        }
        multipart_state = new_question.answers.new(new_multipart_question)

        if multipart_state.save!
          i += 1
        else
          fail "Multipart(Answer::Class) did not save!"
        end
      end
    end
  end

  def get_tex_file
    File.read(@uplaoded_tex_file)
  end
end
