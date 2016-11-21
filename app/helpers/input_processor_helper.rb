module InputProcessorHelper
  NUM_PATTERN = /([0-9]+\.[0-9]+)|(\-[0-9]+\.[0-9]+)|(\d)|(\-\d)/


  def coordinates_parser(string)
    coord_array = sanitize_spaces(string).scan(/\((.*?)\)/i).flatten
    result = coord_array.map { |coord|
      coord.split(',').map { |xy|
        xy.replace(rational_formatter(xy)) if xy =~ /\-/
        Rational(xy)
      }.flatten #The output looks like such "(-1,2), (2, 5)" => [[(-1/1), (2/1)], [(2/1), (5/1)]]
    }
  end

  def normal_ans_parser(string)
    normal_ans_array = sanitize_spaces(string).split(",")
    standardise_input(normal_ans_array)
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
      return Rational(rational_formatter(ans))
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
    standardise_input(formatted)
  end

  def sanitize_spaces(string)
    string.gsub(/\s+/, '')
  end

  def rational_formatter(rat_string)
    if rat_string =~ /\// && rat_string =~ /\-/
      if rat_string.scan(/\-/).size >= 2
        rat_string.gsub(/\-/, "")
      else
        rat_string.gsub(/\-/, "").prepend("-")
      end
    else
      rat_string
    end
  end

  def inequality_formatter(string)
    if string =~ /^[a-z]/i
      string
    else
      string.replace(string.reverse)
      string.scan(/[<>]/) { |match|
        if match == "<"
          string.replace(string.gsub("<", ">"))
        elsif match == ">"
          string.replace(string.gsub(">", "<"))
        end
      }
    end

    string.scan(/(=>)|(=<)/) { |match|
      if $1 == "=>"
        string.replace(string.gsub("=>", ">="))
      elsif $2 == "=<"
        string.replace(string.gsub("=<", "<="))
      end
    }
  end

end
