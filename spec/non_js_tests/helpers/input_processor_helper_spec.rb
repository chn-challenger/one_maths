describe InputProcessorHelper, type: :helper do
  let!(:processor) { Class.new { include InputProcessorHelper }.new }

  describe '#single_answer_correctness' do
    it 'compare ["1","2"] with ["1","2"] return 1' do
      question_answer = ["1","2"]
      student_answer = ["1","2"]
      expect(processor.single_answer_correctness(question_answer,student_answer)).to eq 1
    end

    it 'compare ["1","2","3"] with ["3","2","4"] return 0.667' do
      question_answer = ["1","2","3"]
      student_answer = ["3","2","4"]
      expect(processor.single_answer_correctness(question_answer,student_answer)).to eq 0.66666667
    end

    it 'compare ["1","2","3"] with ["6","5","4"] return 0' do
      question_answer = ["1","2","3"]
      student_answer = ["6","5","4"]
      expect(processor.single_answer_correctness(question_answer,student_answer)).to eq 0
    end

    it 'compare ["1",["2"],"3"] with ["6",["2"],"4"] return 0.33333' do
      question_answer = ["1",["2"],"3"]
      student_answer = ["6",["2"],"4"]
      expect(processor.single_answer_correctness(question_answer,student_answer)).to eq 0.33333333
    end

    it 'compare ["1","2","3"] with ["2","3","4","5","6"] return 0.6667' do
      question_answer = ["1","2","3"]
      student_answer = ["2","3","4","5","6"]
      expect(processor.single_answer_correctness(question_answer,student_answer)).to eq 0.66666667
    end
  end

  describe "#sanitize_spaces" do
    it "strips all spacing between characters" do
      test_strings = ["8 > x", "  x = 7", "( 12,3), ( -2 , 3 )"]
      expected = %w(8>x x=7 (12,3),(-2,3))
      test_strings.each_with_index do |string, index|
        expect(processor.sanitize_spaces(string)).to eq expected[index]
      end
    end
  end

  describe "#rationalizer" do
    it "converts a string integer into rational" do
      test_string   = "3 2.3 -3/-2"
      test_2_string = "-3 1/-0"
      expect(processor.rationalizer(test_string)).to eq "#{Rational('3')} #{Rational('2.3')} #{Rational('-3','-2')}"
      expect(processor.rationalizer(test_2_string)).to eq "#{Rational('-3')} 1/-0"
    end

    it "converts a string float into rational" do
      test_string   = "2.22"
      test_2_string = "-2.22"
      expect(processor.rationalizer(test_string)).to eq Rational(test_string).to_s
      expect(processor.rationalizer(test_2_string)).to eq Rational(test_2_string).to_s
    end

    it "converts a string fraction into rational" do
      test_string   = "1/2 f"
      test_2_string = "-1/2 £"
      test_3_string = "$$-1/-2"
      test_4_string = "1/-2Aa"

      expect(processor.rationalizer(test_string)).to eq "#{Rational(1,2)} f"
      expect(processor.rationalizer(test_2_string)).to eq "#{Rational(-1,2)} £"
      expect(processor.rationalizer(test_3_string)).to eq "$$#{Rational(1,2)}"
      expect(processor.rationalizer(test_4_string)).to eq "#{Rational(1,-2)}Aa"
    end

    it "converts floats to 5 d.p." do
      sample_string   = "$5.42"
      sample_string_2 = "78.76545£"
      sample_string_3 = "6.436346262366236f"

      expect(processor.rationalizer(sample_string)).to eq "$#{Rational("5.42000")}"
      expect(processor.rationalizer(sample_string_2)).to eq "#{Rational("78.76545")}£"
      expect(processor.rationalizer(sample_string_3)).to eq "#{Rational("6.43635")}f"
    end

    it 'converts mixture of everything' do
      sample_string = "$1a2.2s-3.3dd4.4f(2/3)(-2/1.2),2.3/-4.5,sadf-4.5/-3.1a2.5a/3//4/0£3/0/0/0/0"
      expected_string = "$1/1a11/5s-33/10dd22/5f(2/3)(-5/3),-23/45,sadf45/31a5/2a/3/1//4/0£3/0/0/0/0/1"
      expect(processor.rationalizer(sample_string)).to eq expected_string
    end
  end

  describe "#sanitize_letters" do
    it "strips a string from all alphabetical characters" do
      sample_answer   = "asidh2.343, sad -3,ads1/2"
      sample_answer_2 = "(dasd3, -34dsd), dasd(-1sd/d9, 10i0/2d)das"
      expect(processor.sanitize_letters(sample_answer)).to eq "2.343,  -3,1/2"
      expect(processor.sanitize_letters(sample_answer_2)).to eq "(3, -34), (-1/9, 100/2)"
    end
  end

  describe "#normal_ans_parser" do
    it "formats input to rationals for comparison" do
      test_string = "3/2£,f-4/3,s1/2"
      expect(processor.normal_ans_parser(test_string)).to eq ["3/2£","-4/3","1/2"]
    end
  end

  describe "#inequality_parser" do
    it "formats input to rationals for comparison" do
      test_string = "8/1<=x,x=>-5/4,8/5=x"
      expect(processor.inequality_parser(test_string)).to eq ["x>=8/1", "x>=-5/4", "x=8/5"]
    end
  end
  #
  # describe "alphabetical answers parser" do
  #   it "processes alphabetical answers" do
  #     sample_answer   = "Minimum"
  #     sample_answer_2 = "Inflection point"
  #     expect(processor.alpha_parser(sample_answer)).to eq ["minimum"]
  #     expect(processor.alpha_parser(sample_answer_2)).to eq ["inflection", "point"]
  #   end
  # end
  #
  # describe "answer relay recognises" do
  #   it "coordinates and processes them" do
  #     sample_answer     = "(-1, 3/5)"
  #     sample_answer_2   = "(400, -124), (0,-1/-3)"
  #     sample_answer_3   = "(5/2, 2.34), (-3, -2.42)"
  #     sample_answer_4   = "(24/-525, 14), (4, -98)"
  #     sample_answer_5   = "(2.45544, -43.32452), (86.45786, -532.52356)"
  #     sample_answer_6   = "(-2.12411, -9/-0), (43, -6/5)"
  #
  #     expect(processor.answer_relay(sample_answer)).to eq [[Rational("-1"), Rational("3/5")]].sort
  #     expect(processor.answer_relay(sample_answer_2)).to eq [[Rational("400"), Rational("-124")], [Rational("0"), Rational("1/3")]].sort
  #     expect(processor.answer_relay(sample_answer_3)).to eq [[Rational("5/2"), Rational("2.34")], [Rational("-3"), Rational("-2.42")]].sort
  #     expect(processor.answer_relay(sample_answer_4)).to eq [[Rational("-24/525"), Rational("14")], [Rational("4"), Rational("-98")]].sort
  #     expect(processor.answer_relay(sample_answer_5)).to eq [[Rational("2.45544"), Rational("-43.32452")], [Rational("86.45786"), Rational("-532.52356")]].sort
  #     expect(processor.answer_relay(sample_answer_6)).to eq [[Rational("-2.12411"), Rational("0")], [Rational("43"), Rational("-6/5")]].sort
  #   end
  #
  #   it "inequalities and processes them" do
  #     sample_answer     = "x => 8"
  #     sample_answer_2   = "x=>5, 6=y, 100=z"
  #     sample_answer_3   = "6>=g, 9<=  j, -9>=j"
  #     sample_answer_4   = "1/2=>h, 20=<s, 100.124<=l"
  #
  #
  #     expect(processor.answer_relay(sample_answer)).to eq ["x>=#{Rational("8")}"]
  #     expect(processor.answer_relay(sample_answer_2)).to eq ["x>=5/1", "y=6/1", "z=100/1"].sort
  #     expect(processor.answer_relay(sample_answer_3)).to eq ["g<=6/1", "j>=9/1", "j<=-9/1"].sort
  #     expect(processor.answer_relay(sample_answer_4)).to eq ["h<=1/1", "s>=20/1", "l>=100/1"].sort
  #   end
  #
  #   it "standard answers and processes them" do
  #     sample_answer = "-42, 3.421, -1/2"
  #     expect(processor.answer_relay(sample_answer)).to eq [Rational("-42").to_s, Rational("3.421").to_s, Rational("-1/2").to_s].sort
  #   end
  #
  #   it "letter characters only answers and processes them" do
  #     sample_answer = "Minimum"
  #     expect(processor.answer_relay(sample_answer)).to eq ["minimum"]
  #   end
  #
  #   it "unkown type and raises an error" do
  #     sample_answer = "y=2x+10"
  #     expect {processor.answer_relay(sample_answer)}.to raise_error(AnswerTypeError, "The format for #{sample_answer} is not supported.")
  #   end
  # end



  describe "#standardise_answer" do
    context 'normal type' do
      it "returns 100%" do
        sample_answer = "3, -2.22, -1/-2"
        answer_type =  "normal"
        sample_answer = "3, -2.22, 0.5"
        expect(processor.standardise_answer(answer_type,sample_answer,sample_answer)).to eq 1
      end

      it 'returns 80%' do


      end

      it 'returns 50%' do

      end

      it 'returns 0%' do

      end
    end

    context 'inequality type' do

    end

    context 'coordinates type' do

    end
  end

end


# describe "coordinates" do
#   it "convert coordinates input into rationals" do
#     coords_1 = "(2,4), (6, 9)"
#     coords_2 = "(7.11, 16.72), (6.98, -25.66)"
#     coords_3 = "(-9.57, 5.17), (-8.01, -29.98)"
#     coords_4 = "(-7.81, 10.61), (-9.58, -25.36)"
#     coords_5 = "(-6.8, -8.67), (-5.27, -27.06)"
#     coords_6 = "(-9.99, 19.08), (28.82, 8.12)"
#     coords_7 = "(4.28, 4.61), (-2.12, -12.24)"
#     coords_8 = "(-11.47, -8.58), (29.12, -6.24)"
#     coords_9 = "(9.14, 8.45), (-6.58, 6.49)"
#     coords_10 = "(-2.81, 16.07), (15.88, 1.29)"
#     coords_11 = "(9.48, 16.94), (17.25, 0.54)"
#     coords_12 = "(-6.15, 15.75), (17.65, -15.51)"
#     coords_13 = "(-5.98, 16.81), (22.14, -23.67)"
#     coords_14 = "(-1.95, -6.42), (7.5, -14.34)"
#     coords_15 = "(-5.38, 18.59), (-9.02, -12.78)"
#     coords_16 = "(-3.06, 17.86), (13.3, -11.02)"
#     coords_17 = "(-14.1, 19.57), (23.75, -14.85)"
#     coords_18 = "(-11.55, -0.55), (-4.04, -15.84)"
#     coords_19 = "(6.21, 12.46), (0.26, -16.35)"
#     coords_20 = "(-17.82, 9.94), (26.07, -15.57)"
#
#     expect(processor.coordinates_parser(coords_1)).to eq [[Rational('2'),Rational('4')],[Rational('6'),Rational('9')]]
#     expect(processor.coordinates_parser(coords_2)).to eq [[Rational('7.11'),Rational('16.72')],[Rational('6.98'),Rational('-25.66')]].sort
#     expect(processor.coordinates_parser(coords_3)).to eq [[Rational('-9.57'),Rational('5.17')],[Rational('-8.01'),Rational('-29.98')]].sort
#     expect(processor.coordinates_parser(coords_4)).to eq [[Rational('-7.81'),Rational('10.61')],[Rational('-9.58'),Rational('-25.36')]].sort
#     expect(processor.coordinates_parser(coords_5)).to eq [[Rational('-6.8'),Rational('-8.67')],[Rational('-5.27'),Rational('-27.06')]].sort
#     expect(processor.coordinates_parser(coords_6)).to eq [[Rational('-9.99'),Rational('19.08')],[Rational('28.82'),Rational('8.12')]].sort
#     expect(processor.coordinates_parser(coords_7)).to eq [[Rational('4.28'),Rational('4.61')],[Rational('-2.12'),Rational('-12.24')]].sort
#     expect(processor.coordinates_parser(coords_8)).to eq [[Rational('-11.47'),Rational('-8.58')],[Rational('29.12'),Rational('-6.24')]].sort
#     expect(processor.coordinates_parser(coords_9)).to eq [[Rational('9.14'),Rational('8.45')],[Rational('-6.58'),Rational('6.49')]].sort
#     expect(processor.coordinates_parser(coords_10)).to eq [[Rational('-2.81'),Rational('16.07')],[Rational('15.88'),Rational('1.29')]].sort
#     expect(processor.coordinates_parser(coords_11)).to eq [[Rational('9.48'),Rational('16.94')],[Rational('17.25'),Rational('0.54')]].sort
#     expect(processor.coordinates_parser(coords_12)).to eq [[Rational('-6.15'),Rational('15.75')],[Rational('17.65'),Rational('-15.51')]].sort
#     expect(processor.coordinates_parser(coords_13)).to eq [[Rational('-5.98'),Rational('16.81')],[Rational('22.14'),Rational('-23.67')]].sort
#     expect(processor.coordinates_parser(coords_14)).to eq [[Rational('-1.95'),Rational('-6.42')],[Rational('7.5'),Rational('-14.34')]].sort
#     expect(processor.coordinates_parser(coords_15)).to eq [[Rational('-5.38'),Rational('18.59')],[Rational('-9.02'),Rational('-12.78')]].sort
#     expect(processor.coordinates_parser(coords_16)).to eq [[Rational('-3.06'),Rational('17.86')],[Rational('13.3'),Rational('-11.02')]].sort
#     expect(processor.coordinates_parser(coords_17)).to eq [[Rational('-14.1'),Rational('19.57')],[Rational('23.75'),Rational('-14.85')]].sort
#     expect(processor.coordinates_parser(coords_18)).to eq [[Rational('-11.55'),Rational('-0.55')],[Rational('-4.04'),Rational('-15.84')]].sort
#     expect(processor.coordinates_parser(coords_19)).to eq [[Rational('6.21'),Rational('12.46')],[Rational('0.26'),Rational('-16.35')]].sort
#     expect(processor.coordinates_parser(coords_20)).to eq [[Rational('-17.82'),Rational('9.94')],[Rational('26.07'),Rational('-15.57')]].sort
#   end
#
#   it "converts fractions to rational coordinates" do
#     coords = "(-1/3, 3/4), (-3/4, -1/-3)"
#
#     expect(processor.coordinates_parser(coords)).to eq [[Rational('-1/3'),Rational('3/4')],[Rational('-3/4'),Rational('1/3')]].sort
#   end
# end
#
# describe "rational formatter" do
#   it "converts 1/-2 to -1/2" do
#     test_string = "1/-2"
#     expect(processor.rational_formatter(test_string)).to eq "-1/2"
#   end
#
#   it "converts -3/-2 to 3/2" do
#     test_string = "-3/-2"
#     expect(processor.rational_formatter(test_string)).to eq "3/2"
#   end
# end


#
# describe "standardise input" do
#   it "converts all floats, integers and fractions to standardised rationals" do
#     test_string = ["33", "2.22", "1/2"]
#     test_2_string = "3,2.22, 1/2"
#     test_3_string = "2.22"
#     test_4_string = "3"
#     test_5_string = "1/2"
#     test_6_string = "-1/2"
#     test_7_string = "-3,-2.22, -1/-2"
#     test_array    = ["-3", "-2.22", "-1/-2"]
#
#     expect(processor.standardise_input(test_string)).to eq [Rational("33").to_s, Rational("2.22").to_s, Rational("1/2").to_s]
#     expect(processor.standardise_input(test_2_string)).to eq [Rational("3").to_s, Rational("2.22").to_s, Rational("1/2").to_s]
#     expect(processor.standardise_input(test_3_string)).to eq [Rational("2.22").to_s]
#     expect(processor.standardise_input(test_4_string)).to eq [Rational("3").to_s]
#     expect(processor.standardise_input(test_5_string)).to eq [Rational("1/2").to_s]
#     expect(processor.standardise_input(test_6_string)).to eq [Rational("-1/2").to_s]
#     expect(processor.standardise_input(test_7_string)).to eq [Rational("-3").to_s, Rational("-2.22").to_s, Rational("1/2").to_s]
#     expect(processor.standardise_input(test_array)).to eq [Rational("-3").to_s, Rational("-2.22").to_s, Rational("1/2").to_s]
#   end
# end
#
# describe "inequality formatter" do
#   it "converts '8 <= x' to 'x >= 8'" do
#     test_string = "8 <= x"
#     expect(processor.inequality_formatter(test_string)).to eq "x>=8"
#   end
#
#   it "converts '8 => x' to 'x <= 8'" do
#     test_string = "8 => x"
#     expect(processor.inequality_formatter(test_string)).to eq "x<=8"
#   end
#
#   it "converts '8 =< x' to 'x >= 8'" do
#     test_string = "8 =< x"
#     expect(processor.inequality_formatter(test_string)).to eq "x>=8"
#   end
#
#   it "converts '8 >= x' to 'x <= 8'" do
#     test_string = "8 >= x"
#     expect(processor.inequality_formatter(test_string)).to eq "x<=8"
#   end
#
#   it "corrects 'x =< 8' to 'x <= 8'" do
#     test_string = "x =< 8"
#     expect(processor.inequality_formatter(test_string)).to eq "x <= 8"
#   end
#
#   it "corrects 'x => 8' to 'x >= 8'" do
#     test_string = "x => 8"
#     expect(processor.inequality_formatter(test_string)).to eq "x >= 8"
#   end
# end
#


# it "compates two answers and returns 100%" do
#   # sample_answer    = "x=>5, 6=y, 100=z"
#   #   answer_type         =  "inequality"
#   # sample_answer         = "100=z, x=>5, 6=y"
#   # sample_answer_2  = "(5/2, 2.34), (-3, -2.42)"
#   #   answer_type_2         = "coordinates"
#   # sample_answer_2       = "(5/2, 2.34), (-3, -2.42)"
#   sample_answer_3  = "3, -2.22, 1/2"
#   answer_type_3           =  "normal"
#   sample_answer_3       = "3, -2.22, 0.5"
#   # sample_answer_4  = "InfLection PoINT"
#   #   answer_type_4           = "words"
#   # sample_answer_4       = "inflection Point"
#
#   # expect(processor.standardise_answer(answer_type,sample_answer, sample_answer)).to eq 1
#   # expect(processor.standardise_answer(answer_type_2,sample_answer_2, sample_answer_2)).to eq 1
#   expect(processor.standardise_answer(answer_type_3,sample_answer_3, sample_answer_3)).to eq 1
#   # expect(processor.standardise_answer(answer_type_4,sample_answer_4, sample_answer_4)).to eq 1
# end

# it "compares two answers and returns false" do
#   sample_answer    = "x=>5, 6=y, 100=z", answer_type: "inequality" }
#   sample_answer         = "100=>z, x=>5, 6=y"
#   sample_answer_2  = "(5/2, 2.34), (-3, -2.42)", answer_type: "coordinates" }
#   sample_answer_2       = "(5/2, 2.34), (3, 2.42)"
#   sample_answer_3  = "3, -2.22, 1/2", answer_type: "normal" }
#   sample_answer_3       = "3, 2.22, -1/2"
#   sample_answer_4  = "InfLection PoINT", answer_type: "words" }
#   sample_answer_4       = "minimum"
#
#   expect(processor.standardise_answer(answer_type,sample_answer, sample_answer)).to eq false
#   expect(processor.standardise_answer(answer_type_2,sample_answer_2, sample_answer_2)).to eq false
#   expect(processor.standardise_answer(answer_type_3,sample_answer_3, sample_answer_3)).to eq false
#   expect(processor.standardise_answer(answer_type_4,sample_answer_4, sample_answer_4)).to eq false
# end
#
# it "raise an exception if 'equation' type is specified" do
#   sample_answer = "x=>5, 6=y, 100=z"
#     answer_type   = "equation"
#   sample_answer      = "100=>z, x=>5, 6=y"
#   expect { processor.standardise_answer(answer_type, sample_answer, sample_answer) }.to raise_error(AnswerTypeError, "The format for equation is not supported yet.")
# end
#
# it "raise an exception if answer_type is 'nil'" do
#   sample_answer = "x=>5, 6=y, 100=z"
#   answer_type =  nil
#   sample_answer      = "100=>z, x=>5, 6=y"
#   expect { processor.standardise_answer(answer_type, sample_answer, sample_answer) }.to raise_error(AnswerTypeError, "No type has been specified.")
# end
#
# it "compares two answers and returns false" do
#   sample_answer    = "x=>5, 6=y, 100=z", answer_type: "inequality" }
#   sample_answer         = "100=>z, x=>5, 6=y"
#   sample_answer_2  = "(5/2, 2.34), (-3, -2.42)", answer_type: "coordinates" }
#   sample_answer_2       = "(5/2, 2.34), (3, 2.42)"
#   sample_answer_3  = "3, -2.22, 1/2", answer_type: "normal" }
#   sample_answer_3       = "3, 2.22, -1/2"
#   sample_answer_4  = "InfLection PoINT", answer_type: "words" }
#   sample_answer_4       = "minimum"
#
#   expect(processor.standardise_answer(answer_type,sample_answer, sample_answer)).to eq false
#   expect(processor.standardise_answer(answer_type_2,sample_answer_2, sample_answer_2)).to eq false
#   expect(processor.standardise_answer(answer_type_3,sample_answer_3, sample_answer_3)).to eq false
#   expect(processor.standardise_answer(answer_type_4,sample_answer_4, sample_answer_4)).to eq false
# end
#
# it "raise an exception if 'equation' type is specified" do
#   sample_answer = "x=>5, 6=y, 100=z"
#     answer_type   = "equation"
#   sample_answer      = "100=>z, x=>5, 6=y"
#   expect { processor.standardise_answer(answer_type, sample_answer, sample_answer) }.to raise_error(AnswerTypeError, "The format for equation is not supported yet.")
# end
#
# it "raise an exception if answer_type is 'nil'" do
#   sample_answer = "x=>5, 6=y, 100=z"
#   answer_type =  nil
#   sample_answer      = "100=>z, x=>5, 6=y"
#   expect { processor.standardise_answer(answer_type, sample_answer, sample_answer) }.to raise_error(AnswerTypeError, "No type has been specified.")
# end
