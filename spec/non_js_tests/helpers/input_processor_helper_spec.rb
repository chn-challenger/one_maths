describe InputProcessorHelper, type: :helper do
  let!(:processor) { Class.new { include InputProcessorHelper }.new }

  describe "coordinates" do
    it "convert coordinates input into rationals" do
      coords_1 = "(2,4), (6, 9)"
      coords_2 = "(7.11, 16.72), (6.98, -25.66)"
      coords_3 = "(-9.57, 5.17), (-8.01, -29.98)"
      coords_4 = "(-7.81, 10.61), (-9.58, -25.36)"
      coords_5 = "(-6.8, -8.67), (-5.27, -27.06)"
      coords_6 = "(-9.99, 19.08), (28.82, 8.12)"
      coords_7 = "(4.28, 4.61), (-2.12, -12.24)"
      coords_8 = "(-11.47, -8.58), (29.12, -6.24)"
      coords_9 = "(9.14, 8.45), (-6.58, 6.49)"
      coords_10 = "(-2.81, 16.07), (15.88, 1.29)"
      coords_11 = "(9.48, 16.94), (17.25, 0.54)"
      coords_12 = "(-6.15, 15.75), (17.65, -15.51)"
      coords_13 = "(-5.98, 16.81), (22.14, -23.67)"
      coords_14 = "(-1.95, -6.42), (7.5, -14.34)"
      coords_15 = "(-5.38, 18.59), (-9.02, -12.78)"
      coords_16 = "(-3.06, 17.86), (13.3, -11.02)"
      coords_17 = "(-14.1, 19.57), (23.75, -14.85)"
      coords_18 = "(-11.55, -0.55), (-4.04, -15.84)"
      coords_19 = "(6.21, 12.46), (0.26, -16.35)"
      coords_20 = "(-17.82, 9.94), (26.07, -15.57)"

      expect(processor.coordinates_parser(coords_1)).to eq [[Rational('2'),Rational('4')],[Rational('6'),Rational('9')]]
      expect(processor.coordinates_parser(coords_2)).to eq [[Rational('7.11'),Rational('16.72')],[Rational('6.98'),Rational('-25.66')]]
      expect(processor.coordinates_parser(coords_3)).to eq [[Rational('-9.57'),Rational('5.17')],[Rational('-8.01'),Rational('-29.98')]]
      expect(processor.coordinates_parser(coords_4)).to eq [[Rational('-7.81'),Rational('10.61')],[Rational('-9.58'),Rational('-25.36')]]
      expect(processor.coordinates_parser(coords_5)).to eq [[Rational('-6.8'),Rational('-8.67')],[Rational('-5.27'),Rational('-27.06')]]
      expect(processor.coordinates_parser(coords_6)).to eq [[Rational('-9.99'),Rational('19.08')],[Rational('28.82'),Rational('8.12')]]
      expect(processor.coordinates_parser(coords_7)).to eq [[Rational('4.28'),Rational('4.61')],[Rational('-2.12'),Rational('-12.24')]]
      expect(processor.coordinates_parser(coords_8)).to eq [[Rational('-11.47'),Rational('-8.58')],[Rational('29.12'),Rational('-6.24')]]
      expect(processor.coordinates_parser(coords_9)).to eq [[Rational('9.14'),Rational('8.45')],[Rational('-6.58'),Rational('6.49')]]
      expect(processor.coordinates_parser(coords_10)).to eq [[Rational('-2.81'),Rational('16.07')],[Rational('15.88'),Rational('1.29')]]
      expect(processor.coordinates_parser(coords_11)).to eq [[Rational('9.48'),Rational('16.94')],[Rational('17.25'),Rational('0.54')]]
      expect(processor.coordinates_parser(coords_12)).to eq [[Rational('-6.15'),Rational('15.75')],[Rational('17.65'),Rational('-15.51')]]
      expect(processor.coordinates_parser(coords_13)).to eq [[Rational('-5.98'),Rational('16.81')],[Rational('22.14'),Rational('-23.67')]]
      expect(processor.coordinates_parser(coords_14)).to eq [[Rational('-1.95'),Rational('-6.42')],[Rational('7.5'),Rational('-14.34')]]
      expect(processor.coordinates_parser(coords_15)).to eq [[Rational('-5.38'),Rational('18.59')],[Rational('-9.02'),Rational('-12.78')]]
      expect(processor.coordinates_parser(coords_16)).to eq [[Rational('-3.06'),Rational('17.86')],[Rational('13.3'),Rational('-11.02')]]
      expect(processor.coordinates_parser(coords_17)).to eq [[Rational('-14.1'),Rational('19.57')],[Rational('23.75'),Rational('-14.85')]]
      expect(processor.coordinates_parser(coords_18)).to eq [[Rational('-11.55'),Rational('-0.55')],[Rational('-4.04'),Rational('-15.84')]]
      expect(processor.coordinates_parser(coords_19)).to eq [[Rational('6.21'),Rational('12.46')],[Rational('0.26'),Rational('-16.35')]]
      expect(processor.coordinates_parser(coords_20)).to eq [[Rational('-17.82'),Rational('9.94')],[Rational('26.07'),Rational('-15.57')]]
    end

    it "converts fractions to rational coordinates" do
      coords = "(-1/3, 3/4), (-3/4, -1/-3)"

      expect(processor.coordinates_parser(coords)).to eq [[Rational('-1/3'),Rational('3/4')],[Rational('-3/4'),Rational('1/3')]]
    end
  end

  describe "rational formatter" do
    it "converts 1/-2 to -1/2" do
      test_string = "1/-2"
      expect(processor.rational_formatter(test_string)).to eq "-1/2"
    end

    it "converts -3/-2 to 3/2" do
      test_string = "-3/-2"
      expect(processor.rational_formatter(test_string)).to eq "3/2"
    end
  end

  describe "sanitize spaces" do
    it "strips all spacing between characters" do
      test_strings = ["8 > x", "  x = 7", "( 12,3), ( -2 , 3 )"]
      expected = %w(8>x x=7 (12,3),(-2,3))
      test_strings.each_with_index do |string, index|
        expect(processor.sanitize_spaces(string)).to eq expected[index]
      end
    end
  end

  describe "standardise input" do
    it "converts all floats, integers and fractions to standardised rationals" do
      test_string = ["33", "2.22", "1/2"]
      test_2_string = "3,2.22, 1/2"
      test_3_string = "2.22"
      test_4_string = "3"
      test_5_string = "1/2"
      test_6_string = "-1/2"
      test_7_string = "-3,-2.22, -1/-2"
      test_array    = ["-3", "-2.22", "-1/-2"]

      expect(processor.standardise_input(test_string)).to eq [Rational("33").to_s, Rational("2.22").to_s, Rational("1/2")]
      expect(processor.standardise_input(test_2_string)).to eq [Rational("3").to_s, Rational("2.22").to_s, Rational("1/2")]
      expect(processor.standardise_input(test_3_string)).to eq [Rational("2.22").to_s]
      expect(processor.standardise_input(test_4_string)).to eq [Rational("3").to_s]
      expect(processor.standardise_input(test_5_string)).to eq [Rational("1/2")]
      expect(processor.standardise_input(test_6_string)).to eq [Rational("-1/2")]
      expect(processor.standardise_input(test_7_string)).to eq [Rational("-3").to_s, Rational("-2.22").to_s, Rational("1/2")]
      expect(processor.standardise_input(test_array)).to eq [Rational("-3").to_s, Rational("-2.22").to_s, Rational("1/2")]
    end
  end

  describe "inequality formatter" do
    it "converts '8 <= x' to 'x >= 8'" do
      test_string = "8 <= x"
      expect(processor.inequality_formatter(test_string)).to eq "x >= 8"
    end

    it "converts '8 => x' to 'x <= 8'" do
      test_string = "8 => x"
      expect(processor.inequality_formatter(test_string)).to eq "x <= 8"
    end

    it "converts '8 =< x' to 'x >= 8'" do
      test_string = "8 =< x"
      expect(processor.inequality_formatter(test_string)).to eq "x >= 8"
    end

    it "converts '8 >= x' to 'x <= 8'" do
      test_string = "8 >= x"
      expect(processor.inequality_formatter(test_string)).to eq "x <= 8"
    end

    it "corrects 'x =< 8' to 'x <= 8'" do
      test_string = "x =< 8"
      expect(processor.inequality_formatter(test_string)).to eq "x <= 8"
    end

    it "corrects 'x => 8' to 'x >= 8'" do
      test_string = "x => 8"
      expect(processor.inequality_formatter(test_string)).to eq "x >= 8"
    end
  end

  describe "rationalizer" do
    it "converts a string integer into rational" do
      test_string   = "3"
      test_2_string = "-3"
      expect(processor.rationalizer(test_string)).to eq Rational(test_string).to_s
      expect(processor.rationalizer(test_2_string)).to eq Rational(test_2_string).to_s
    end

    it "converts a string float into rational" do
      test_string   = "2.22"
      test_2_string = "-2.22"
      expect(processor.rationalizer(test_string)).to eq Rational(test_string).to_s
      expect(processor.rationalizer(test_2_string)).to eq Rational(test_2_string).to_s
    end

    it "converts a string fraction into rational" do
      test_string   = "1/2"
      test_2_string = "-1/2"
      test_3_string = "-1/-2"
      test_4_string = "1/-2"

      expect(processor.rationalizer(test_string)).to eq Rational(test_string)
      expect(processor.rationalizer(test_2_string)).to eq Rational(test_2_string)
      expect(processor.rationalizer(test_3_string)).to eq Rational("1/2")
      expect(processor.rationalizer(test_4_string)).to eq Rational("-1/2")
    end
  end

  describe "normal answers parser" do
    it "formats input to rationals for comparison" do
      test_string = "3, 2.22, 1/2"
      expect(processor.normal_ans_parser(test_string)).to eq [Rational("3").to_s, Rational("2.22").to_s, Rational("1/2")]
    end
  end

  describe "inequality parser" do
    it "formats input to rationals for comparison" do
      test_string = "8 <= x, x => 8, 8 = x"
      expect(processor.inequality_parser(test_string)).to eq ["x>=#{Rational("8")}", "x>=#{Rational("8")}", "x=#{Rational("8")}"]
    end
  end

  describe "answer relay recognises" do
    it "coordinates and processes them" do
      sample_answer     = "(-1, 3/5)"
      sample_answer_2   = "(400, -124), (0,-1/-3)"
      sample_answer_3   = "(5/2, 2.34), (-3, -2.42)"
      sample_answer_4   = "(24/-525, 14), (4, -98)"
      sample_answer_5   = "(2.45544, -43.32452), (86.45786, -532.52356)"
      sample_answer_6   = "(-2.12411, -9/-0), (43, -6/5)"

      expect(processor.answer_relay(sample_answer)).to eq [[Rational("-1"), Rational("3/5")]]
      expect(processor.answer_relay(sample_answer_2)).to eq [[Rational("400"), Rational("-124")], [Rational("0"), Rational("1/3")]]
      expect(processor.answer_relay(sample_answer_3)).to eq [[Rational("5/2"), Rational("2.34")], [Rational("-3"), Rational("-2.42")]]
      expect(processor.answer_relay(sample_answer_4)).to eq [[Rational("-24/525"), Rational("14")], [Rational("4"), Rational("-98")]]
      expect(processor.answer_relay(sample_answer_5)).to eq [[Rational("2.45544"), Rational("-43.32452")], [Rational("86.45786"), Rational("-532.52356")]]
      expect(processor.answer_relay(sample_answer_6)).to eq [[Rational("-2.12411"), Rational("0")], [Rational("43"), Rational("-6/5")]]
    end

    it "inequalities and processes them" do
      sample_answer     = "x => 8"
      sample_answer_2   = "x=>5, 6=y, 100=z"
      sample_answer_3   = "6>=g, 9<=  j, -9>=j"
      sample_answer_4   = "1/2=>h, 20=<s, 100.124<=l"

      expect(processor.answer_relay(sample_answer)).to eq ["x>=#{Rational("8")}"]
      expect(processor.answer_relay(sample_answer_2)).to eq ["x>=5/1", "y=6/1", "z=1/1"]
      expect(processor.answer_relay(sample_answer_3)).to eq
      expect(processor.answer_relay(sample_answer_4)).to eq
    end

    it "standard answers and processes them" do
      sample_answer = "-42, 3.421, -1/2"
      expect(processor.answer_relay(sample_answer)).to eq [Rational("-42").to_s, Rational("3.421").to_s, Rational("-1/2")]
    end

    it "letter characters only answers and processes them" do
      sample_answer = "Minimum"
      expect(processor.answer_relay(sample_answer)).to eq ["minimum"]
    end

    it "unkown type and raises an error" do
      sample_answer = "y=2x+10"
      expect {processor.answer_relay(sample_answer)}.to raise_error(TypeError, "The format for #{sample_answer} is not supported.")
    end
  end

end
