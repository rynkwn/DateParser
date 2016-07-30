require_relative "../date_parser"

describe DateParser do
  
  #########################################################
  ##
  ## Options Testing
  ##
    
  # * +:parse_single_years+ - Parse single ints as years. Defaults to false.
  #
  # * +:parse_ambiguous_dates+ - Some phrases are not necessarily dates depending
  #   on context. For example "1st" may not refer to 
  #   the 1st of a month. This option toggles whether or not those
  #   phrases are considered dates. Defaults to true.
  describe ".parse" do
    
    context "Not using unique option" do
      text = "Sunday, Sunday, Sunday!"
      creation_date = Date.parse("July 15, 2016")
      answer = [Date.parse("July 17, 2016"), 
                Date.parse("July 17, 2016"), 
                Date.parse("July 17, 2016")]
      
      it "correctly gets repeated dates" do
        expect(DateParser::parse(text, creation_date, unique: false)).to eql(answer)
      end
    end
    
    context "Using unique option" do
      text = "Sunday, Sunday, Sunday!"
      creation_date = Date.parse("July 15, 2016")
      answer = [Date.parse("July 17, 2016")]
      
      it "correctly gets only unique dates" do
        expect(DateParser::parse(text, creation_date, unique: true)).to eql(answer)
      end
    end
    
    context "Using nil date option" do
      text = "No dates"
      creation_date = Date.parse("July 15, 2016")
      nil_date = Date.parse("July 17, 2016")
      answer = [Date.parse("July 17, 2016")]
      
      it "correctly returns the nil_date" do
        expect(DateParser::parse(text, creation_date, nil_date: nil_date)).to eql(answer)
      end
    end
    
    context "Using the parse_single_years option" do
      text = "2000"
      creation_date = Date.parse("July 15, 2016")
      answer = [Date.parse("January 1, 2000")]
      
      it "correctly parses ints as years" do
        expect(DateParser::parse(text, creation_date, parse_single_years: true)).to eql(answer)
      end
    end
    
    context "Setting the parse_ambiguous_dates option to false" do
      text = "He was 1st!"
      creation_date = Date.parse("July 15, 2016")
      answer = []
      
      it "ignores ambiguous phrases" do
        expect(DateParser::parse(text, creation_date, parse_ambiguous_dates: false)).to eql(answer)
      end
    end
    
    context "Setting unique and parse_single_years" do
      text = "12 20 32 402 20"
      creation_date = Date.parse("July 15, 2016")
      answer = [Date.parse("January 1, 12"),
                Date.parse("January 1, 20"),
                Date.parse("January 1, 32"),
                Date.parse("January 1, 402")]
      
      it "Returns unique dates and parses ints as years." do
        expect(DateParser::parse(text, creation_date, parse_ambiguous_dates: false)).to eql(answer)
      end
    end
  end
  
  #########################################################
  ##
  ## Edge Cases
  ##
  
  describe ".parse" do
    context "Parse fully numeric date" do
      text = "2012-02-12"
      answer = [Date.parse("2012-02-12")]
      
      it "correctly grabs the date" do
        expect(DateParser::parse(text)).to eql(answer)
      end
    end
    
    context "Parse American fully numeric date" do
      text = "7-24-2015"
      answer = [Date.parse("July 24, 2015")]
      
      it "correctly grabs the date" do
        expect(DateParser::parse(text)).to eql(answer)
      end
    end
    
    context "Parse International Standard fully numeric date" do
      text = "24-07-2015"
      answer = [Date.parse("24-07-2015")]
      
      it "correctly grabs the date" do
        expect(DateParser::parse(text)).to eql(answer)
      end
    end
  end
end