module InputProcessorHelper

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
    result = normal_ans_array.each
  end

  def inequality_parser(string)

  end

  def sanitize_spaces(string)
    string.gsub(/\s+/, '')
  end

  def rational_formatter(rat_string)
    if rat_string.scan(/\-/).size >= 2
      rat_string.gsub(/\-/, "")
    else
      rat_string.gsub(/\-/, "").prepend("-")
    end
  end

  def inequality_formatter(string)
    if string =~ /^[a-z]/i
      return string
    else
      string.replace(string.reverse)
      string.scan(/(=>)|(=<)|(<)|(>)/) { |match|
        if match == "<"
          string.gsub.("<", ">")
        elsif match == ">"
          string.gsub.(">", "<")
        end

        case match
        when match == "=>"
          string.gsub.("=>", ">=")
        when match == "=<"
          string.gsub.("=<", "<=")
        end
      }
    end
  end

end
