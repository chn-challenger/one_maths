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

  describe "inequality formatter" do
    it "converts '8 <= x' to 'x>=8'" do
      test_string = "8 <= x"
      expect(processor.inequality_formatter(test_string)).to eq "x >= 8"
    end
  end

end
