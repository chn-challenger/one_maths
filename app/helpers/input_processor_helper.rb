module InputProcessorHelper
  NUM_PATTERN = /([0-9]+\.[0-9]+)|(\-[0-9]+\.[0-9]+)|(\d+)|(\-\d+)/

  def answer_relay(ans_string)
    if ans_string =~ /[()]/
      coordinates_parser(ans_string)
    elsif ans_string =~ /(?=.*^((?!\+).)*$)(?=.*[<=>])(?=.*[a-z])(?=.*\d).*/
      inequality_parser(ans_string)
    elsif ans_string[/[a-zA-Z]+/] == ans_string
      alpha_parser(ans_string)
    elsif ans_string =~ /([a-zA-Z])/
      fail TypeError, "The format for #{ans_string} is not supported."
    elsif ans_string =~ /(?!.*[\W])(?=.*\d).*/
      normal_ans_parser(ans_string)
    end
  end

  def coordinates_parser(string)
    coord_array = sanitize_spaces(string).scan(/\((.*?)\)/i).flatten
    result = coord_array.map { |coord|
      coord.split(',').map { |xy|
        Rational(rational_formatter(xy))
      }.flatten #The output looks like such "(-1,2), (2, 5)" => [[(-1/1), (2/1)], [(2/1), (5/1)]]
    }.sort
  end

  def alpha_parser(string)
    string.downcase.split(/\s+/).sort
  end

  def normal_ans_parser(string)
    normal_ans_array = sanitize_spaces(string).split(",")
    standardise_input(normal_ans_array).sort
  end

  def standardise_input(arg)
    if arg.is_a?(Array)
      arg.map do |ans|
        rationalizer(ans)
      end
    else
      arg.split(",").map do |ans|
        rationalizer(ans)
      end
    end
  end

  def rationalizer(ans)
    if ans =~ /\//
      Rational(rational_formatter(ans)).to_s
    else
      ans.gsub(NUM_PATTERN) { |match|
        if match =~ /\./
          Rational(i_to_f(match))
        elsif match
          Rational(rational_formatter(match))
        end
      }
    end
  end

  def i_to_f(num_string)
    "%.5f" % num_string.to_f
  end

  def inequality_parser(string)
    ineq_ans_array = sanitize_spaces(string).split(",")
    formatted = ineq_ans_array.map { |ans| inequality_formatter(ans) }
    standardise_input(formatted).sort
  end

  def sanitize_spaces(string)
    string.gsub(/\s+/, '')
  end

  def rational_formatter(rat_string)

    if rat_string =~ /(\/-0)|(\/0)/
      "0"
    elsif rat_string =~ /\// && rat_string =~ /\-/
      if rat_string.scan(/\-/).size >= 2
        rat_string.gsub(/\-/, "")
      else
        rat_string.gsub(/\-/, "").prepend("-")
      end
    else
      rat_string
    end
  end

  def inequality_reverser(string)
    string[/([a-zA-Z]+)/] + string[/([<=>]+)/] + string[/[-\d]+/]
  end

  def inequality_formatter(string)
    if string =~ /^[a-z]/i
      string
    else
      string = inequality_reverser(string)
      string.gsub(/[<>]/) { |match|
        if match == "<"
          string.replace(string.gsub("<", ">"))
        elsif match == ">"
          string.replace(string.gsub(">", "<"))
        end
      }
    end

    string.gsub(/(=>)|(=<)/) { |match|
      if match == "=>"
        match = ">="
      elsif match == "=<"
        match = "<="
      end
    }
  end

end
