require_relative "../natural_time"

## Run this file with this command:
## rspec lib/spec/natural_time_spec.rb

describe NaturalDateParsing do
  ## I probably want everything to always be wrapped in an array/list.
  ## Consistency is valuable to an end user.
  
  before do
    @date = "April 6th, 2014"
    @text = "Remember to meet me on April 6th, 2014, alright?"
    
    @parsed_date = [Date.parse("April 6th, 2014")]
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
  end
end