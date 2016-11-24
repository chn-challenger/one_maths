module InputProcessorHelper
  NUM_PATTERN       = /(\d+\.\d+)|(\-\d+\.\d+)|(\d+)|(\-\d+)/
  FRACTION_PATTERN  = /(#{NUM_PATTERN})\/(#{NUM_PATTERN})/
  SANITIZE_PATTERN  = /(#{FRACTION_PATTERN})|#{NUM_PATTERN}/

  def single_answer_correctness(question_answer, student_answer)
    ((question_answer & student_answer).length.to_f / question_answer.length).round(8)
  end

  def sanitize_spaces(string)
    string.gsub(/\s+/, '')
  end

  def rationalizer(ans)
    ans.gsub(SANITIZE_PATTERN) do |match|
      if match =~ FRACTION_PATTERN
        if match =~ /(\/-0)|(\/0)/
          match
        else
          match = match.split(/\//)
          Rational(match[0], match[1])
        end
      else
        Rational(round_to_f(match))
      end
    end
  end

  def sanitize_letters(string)
    string.gsub(/[a-zA-Z+]+/, '')
  end

  def normal_ans_parser(string)
    sanitize_letters(string).split(',')
  end

  def inequality_parser(string)
    ineq_ans_array = string.split(',')
    ineq_ans_array.map { |ans| inequality_formatter(ans) }
  end

  def coordinates_parser(string)
    sanitize_letters(string).scan(/\((.*?)\)/i)
  end

  def alpha_parser(string)
    string.downcase.split(/\s+/)
  end

  def standardise_answer(answer_type, question_answer, student_answer)
    question_answer = rationalizer(sanitize_spaces(question_answer))
    student_answer = rationalizer(sanitize_spaces(student_answer))

    case answer_type
    when 'normal'
      question_answer = normal_ans_parser(question_answer)
      student_answer = normal_ans_parser(student_answer)
    when 'inequality'
      question_answer = inequality_parser(question_answer)
      student_answer = inequality_parser(student_answer)
    when 'coordinates'
      question_answer = coordinates_parser(question_answer)
      student_answer = coordinates_parser(student_answer)
    when 'words'
      question_answer = alpha_parser(question_answer)
      student_answer = alpha_parser(student_answer)
    when nil
      raise TypeError, 'No type has been specified.'
    end

    single_answer_correctness(question_answer, student_answer)
  end

  def round_to_f(num_string)
    format('%.5f', num_string.to_f)
  end

  def inequality_reverser(string)
    string[/([a-zA-Z]+)/] + string[/([<=>]+)/] + string[SANITIZE_PATTERN]
  end

  def inequality_formatter(string)
    if string =~ /^[a-z]/i
      string
    else
      string = inequality_reverser(string)
      string.gsub(/[<>]/) do |match|
        if match == '<'
          string.replace(string.tr(match, '>'))
        elsif match == '>'
          string.replace(string.tr(match, '<'))
        end
      end
    end

    string.gsub(/(=>)|(=<)/) do |match|
      if match == '=>'
        '>='
      elsif match == '=<'
        '<='
      end
    end
  end
end
