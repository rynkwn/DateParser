require_relative "../natural_time"

## Run this file with this command:
## rspec lib/spec/natural_time_spec.rb

describe NaturalDateParsing do
  
  #########################################################
  ##
  ## Basic Mechanics Testing
  ##
  
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

describe NaturalDateParsing do
  
  #########################################################
  ##
  ## Edge Cases. More Colloquial Language. More complicated phrases.
  ##
  
  ## TODO: In the future, we may split this off into different tests.
  describe ".interpret_date" do
    context "Running a battery of colloquial/edge case tests" do
      texts = []
      released = []
      answers = []
      
      texts << "La Puerta del Conde (The Count's Gate) is the site in Santo" + 
      "Domingo, Dominican Republic where Francisco del Rosario Sánchez, one of the" + 
      "Dominican Founding Fathers, proclaimed Dominican independence and raised the" + 
      "first Dominican Flag, on February 27, 1844."
      released << nil
      answers << [Date.parse("February 27, 1844")]
      
      texts << "We should go on the 4th if we can."
      released << Date.parse("July 1st 2016")
      answers << [Date.parse("July 4th, 2016")]
      
      texts << "Newsflash: things happen on 02/12!"
      released << Date.parse("January 1st, 1994")
      answers << [Date.parse("February 12, 1994")]
      
      for i in 0..(texts.length - 1) do
        it "returns the expected answer for case " + i.to_s do
          expect(NaturalDateParsing::interpret_date(texts[i], released[i])).to eql(answers[i])
        end
      end
    end
  end
  
end