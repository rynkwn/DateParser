require_relative "../natural_time"

## Run this file with this command:
## rspec lib/spec/natural_time_spec.rb

describe NaturalDateParsing do
  
  before do
    @date = "April 6th, 2014"
    @text = "Remember to meet me on April 6th, 2014, alright?"
    @paragraph = "April 6th, 2014 isn't good for me. We should meet instead on\n" +
                 "February 4th, 2013. Or even March 31st, 2017. No rush."
    
    @parsed_date = [Date.parse("April 6th, 2014")]
    @parsed_date_paragraph = [
                              Date.parse("April 6th, 2014"),
                              Date.parse("February 4th, 2013"),
                              Date.parse("March 31st, 2017")
                              ]
  end
  
  describe ".interpret_date" do
    context "given 'April 6th, 2014'" do
      it "returns Sun, 06 Apr 2014 as a date object" do
        expect(NaturalDateParsing::interpret_date(@date)).to eql(@parsed_date)
      end
    end
    
    context "given a sentence containing April 6th, 2014" do
      it "returns Sun, 06 Apr 2014 as a date object" do 
        expect(NaturalDateParsing::interpret_date(@text)).to eql(@parsed_date)
      end
    end
    
    context "given a paragraph containing several dates" do
      it "returns a list of all dates mentioned in the paragraph" do
        expect(NaturalDateParsing::interpret_date(@paragraph)).to eql(@parsed_date_paragraph)
      end
    end
  end
end