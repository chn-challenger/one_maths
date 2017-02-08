module InputProcessorSupport
  extend ActiveSupport::Concern

  NUM_PATTERN         = /[-+]?\d+\.\d+|[-+]?\d+/
  FRACTION_PATTERN    = /#{NUM_PATTERN}\/#{NUM_PATTERN}/
  SANITIZE_PATTERN    = /#{FRACTION_PATTERN}|#{NUM_PATTERN}/
  INEQUALITY_PATTERN  = /#{SANITIZE_PATTERN}+[<=>]+[[:alpha:]]+[<=>]+#{SANITIZE_PATTERN}/

  def single_answer_correctness(question_answer, student_answer)
    ((question_answer & student_answer).length.to_f / question_answer.length).round(8)
  end

  def sanitize_spaces(string)
    string.encode('UTF-8', invalid: :replace, undef: :replace, replace: ' ').gsub(/\s+/, '')
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
    string.gsub(/[[a-zA-Z]+\+]/, '')
  end

  def normal_ans_parser(string)
    sanitize_letters(string).split(',').reject(&:blank?)
  end

  def inequality_parser(string)
    ineq_ans_array = string.split(/or|,/i).reject(&:blank?)
    ineq_ans_array.map { |ans| inequality_formatter(ans) }
  end

  def coordinates_parser(string)
    sanitize_letters(string).scan(/\((.*?)\)/i)
  end

  def alpha_parser(string)
    string.downcase.split(/\,/).reject(&:blank?)
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
    else
      raise TypeError, "The following as passed as answer_type #{answer_type}"
    end

    single_answer_correctness(question_answer, student_answer)
  rescue TypeError
    return 0
  end

  def round_to_f(num_string)
    format('%.5f', num_string.to_f)
  end

  def inequality_reverser(string)
    return if string.nil? || string == ''
    string[/([[:alpha:]]+)/] + string[/([<=>]+)/] + string[SANITIZE_PATTERN]
  end

  def single_reverser(string, order=0)
    options = [SANITIZE_PATTERN, /[<=>]+/]
    string[options[0 + order]] + string[options[1 + order]]
  end

  def inq_processor(string)
    if !correct_order?(string.scan(SANITIZE_PATTERN))
      letter = string[/[[:alpha:]]/i]
      mod = string.split(/[[:alpha:]]/i).map { |e| sign_reverser(e) } # ["8 <", "> 2"]
      single_reverser(mod[-1]) + letter + single_reverser(mod[0], -1)
    else
      string
    end
  end

  def sign_reverser(string)
    string.gsub(/[<>]/) do |match|
      if match == '<'
        '>'
      elsif match == '>'
        '<'
      end
    end
  end

  def inequality_formatter(string)
    if string =~ INEQUALITY_PATTERN
      string = inq_processor(string)
    elsif string =~ /([#{SANITIZE_PATTERN}]+([\s]+)?[<=>]+([\s]+)?[[:alpha:]]+)/
      string = inequality_reverser(string)
      string = sign_reverser(string)
    end

    string.gsub(/(=>)|(=<)/) do |match|
      if match == '=>'
        '>='
      elsif match == '=<'
        '<='
      end
    end
  end

  private

  def correct_order?(array)
    Rational(array[0]) < Rational(array[-1])
  end
end
