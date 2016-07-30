require_relative "../date_parser"

describe DateParser do
  
  #########################################################
  ##
  ## More Edge Cases looking at specific features.
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