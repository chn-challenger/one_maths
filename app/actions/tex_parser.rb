class TexParser
  include Tagable
  PREFIX = "$\\\\$"
  TRACKER = "B2134"
  REPLACEMENT = "END"
  DOCUMENT_ENDING = "\\end{document}"

  def initialize(uploaded_tex_file)
    @uplaoded_tex_file = uploaded_tex_file
    @questions_raw = []
    @choice_fail = 0
    @multipart_fail = 0
    @elements = [
      "question-text",
      "solution-text",
      "question-experience",
      "question-order-group",
      "question-level",
      "question-tags",
      "choice-text",
      "choice-correct",
      "answer-label",
      "answer-value",
      "answer-hint"
     ]
  end

  def convert
    set_questions_array
    @questions_raw.each do |question|
      converter(question)
    end
  end

  def choice_fail
    @choice_fail
  end

  def multipart_fail
    @multipart_fail
  end

  private

  def set_questions_array
    @questions_raw = sanitize.to_enum(:scan, /#{@elements[0]}(.*?)#{TRACKER}/m).map { Regexp.last_match }
  end

  def tex_sanitizer(tex_string)
    return nil if tex_string.blank?
    tex_string.strip # Removes \n\t\r from string
  end

  def sanitize
    file = get_tex_file.to_s
    @elements.each do |marker|
      if marker == @elements[0]
        file = file.gsub("#{ marker + PREFIX }", TRACKER + marker)
      else
        file = file.gsub("#{ marker + PREFIX }", marker)
      end
    end
    file = file.gsub(PREFIX, REPLACEMENT).gsub(DOCUMENT_ENDING, TRACKER)
  end

  def determine_answer_type(answer_solution)
    matchers = {
      inequality: /[<=>]+/,
      coordinates: /[\(\)]+/,
      normal: /[\d]+/,
      words: /(?=[^\d])(?=[^\s+])[[:alpha:]]+/
    }

    matchers.each do |type, regex|
      return type.to_s if answer_solution =~ regex
    end
  end

  def create_tags()

  end

  def converter(question)
    question = question.to_s
    question_params = {
      question_text: tex_sanitizer(question[/#{@elements[0]}(.*?)#{REPLACEMENT}/m, 1]),
      solution: tex_sanitizer(question[/#{@elements[1]}(.*?)#{REPLACEMENT}/m, 1]),
      experience: tex_sanitizer(question[/#{@elements[2]}(.*?)#{REPLACEMENT}/m, 1]),
      order: tex_sanitizer(question[/#{@elements[3]}(.*?)#{REPLACEMENT}/m, 1]),
      difficulty_level: tex_sanitizer(question[/#{@elements[4]}(.*?)#{REPLACEMENT}/m, 1])
    }

    new_question = Question.create(question_params)

    raw_tags = question[/#{@elements[5]}(.*?)#{REPLACEMENT}/m]
    unless raw_tags.blank?
      tag_names = tag_sanitizer(tex_sanitizer(raw_tags))
      add_tags(new_question, tag_names)
    end

    if question.match("choice-text")

      choices = question.scan(/#{@elements[6]}(.*?)#{REPLACEMENT}/m).flatten
      validity = question.scan(/#{@elements[7]}(.*?)#{REPLACEMENT}/m).flatten

      i = 0

      while i < choices.size do

        new_choice = {
            content: tex_sanitizer(choices[i]),
            correct: tex_sanitizer(validity[i]) == 'true' ? true : false
        }
        choice_state = new_question.choices.new(new_choice)
        # byebug
        if choice_state.save!
          i += 1
        else
          @choice_fail += 1
          fail "Choice did not save!"
        end
      end

    elsif question.match("answer-label")

      label = question.scan(/#{@elements[8]}(.*?)#{REPLACEMENT}/m).flatten
      solution = question.scan(/#{@elements[9]}(.*?)#{REPLACEMENT}/m).flatten
      hint = question.scan(/#{@elements[10]}(.*?)#{REPLACEMENT}/m).flatten

      i = 0

      while i < label.size do
        new_multipart_question = {
          label: tex_sanitizer(label[i]),
          solution: tex_sanitizer(solution[i]),
          hint: tex_sanitizer(hint[i]),
          answer_type: determine_answer_type(tex_sanitizer(solution[i])),
          order: i
        }
        multipart_state = new_question.answers.new(new_multipart_question)

        if multipart_state.save!
          i += 1
        else
          @multipart_fail += 1
          fail "Multipart(Answer::Class) did not save!"
        end
      end
    end
  end

  def get_tex_file
    File.read(@uplaoded_tex_file)
  end
end
