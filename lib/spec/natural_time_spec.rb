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
  
  describe ".interpret_date" do
    
    context "Given a longer sentence containing a date" do
      text = "La Puerta del Conde (The Count's Gate) is the site in Santo" + 
        "Domingo, Dominican Republic where Francisco del Rosario Sánchez, one of the" + 
        "Dominican Founding Fathers, proclaimed Dominican independence and raised the" + 
        "first Dominican Flag, on February 27, 1844."
      released = nil
      answer = [Date.parse("February 27, 1844")]
      
      it "captures the single date" do
        expect(NaturalDateParsing::interpret_date(text, released)).to eql(answer)
      end
    end
    
    context "Colloquial use of date 1" do
      text = "We should go on the 4th if we can."
      released = Date.parse("July 1st 2016")
      answer = [Date.parse("July 4th, 2016")]
      
      it "correctly uses the released parameter" do
        expect(NaturalDateParsing::interpret_date(text, released)).to eql(answer)
      end
    end
    
    context "Correct use of XX/XX format 1" do
      text = "Newsflash: things happen on 02/12!"
      released = Date.parse("January 1st, 1994")
      answer = [Date.parse("February 12, 1994")]
      
      it "correctly grabs the date" do
        expect(NaturalDateParsing::interpret_date(text, released)).to eql(answer)
      end
    end
    
    context "Correctly parses yesterday" do
      text = "Yesterday was certainly a day."
      released = nil
      answer = [Date.parse("January 11, 1994")]
      
      it "correctly grabs the date" do
        expect(NaturalDateParsing::interpret_date(text, released)).to eql(answer)
      end
    end
    
    context "Correctly parses yesterday with a released date" do
      text = "Yesterday was certainly a day."
      released = Date.parse("January 12, 1994")
      answer = [Date.parse("January 11, 1994")]
      
      it "correctly grabs the date" do
        expect(NaturalDateParsing::interpret_date(text, released)).to eql(answer)
      end
    end
    
    context "Single year is correctly parsed" do
      text = "In 1492 Columbus sailed the ocean blue."
      released = nil
      answer = [Date.parse("January 1, 1492")]
      
      it "correctly grabs the date" do
        expect(NaturalDateParsing::interpret_date(text, released)).to eql(answer)
      end
    end
    
    context "Correctly parses month and day in middle of sentence" do
      text = "Something something something march 4 something something"
      released = Date.parse("Jan 1, 2004")
      answer = [Date.parse("March 4, 2004")]
      
      it "correctly grabs the date" do
        expect(NaturalDateParsing::interpret_date(text, released)).to eql(answer)
      end
    end
    
  end
end


describe NaturalDateParsing do
  
  #########################################################
  ##
  ## Colloquial Language samples from volunteers
  ##
  
  describe ".interpret_date" do
    
    context "Colloquial example 1" do
      text = "Charlie Chaplin and Jason Earles (Hannah Montana's brother) were " +
      "alive at the same time for eight months in 1977"
      released = Date.parse("July 6, 2016")
      answer = [Date.parse("January 1, 1977")]
      
      it "correctly grabs the date" do
        expect(NaturalDateParsing::interpret_date(text, released)).to eql(answer)
      end
    end
    
    context "Colloquial example 2" do
      text = "For a job I started this April, I had to parse dates of various " +
      "formats, such as MM-DD-YY, MM/YYYY, and YY-MM-DD. It was infuriating, " +
      "and what I assume you to be doing reminds me of this."
      released = Date.parse("July 6, 2016")
      answer = [Date.parse("April 1, 2016")] ## Reconsider
      
      it "correctly grabs the date" do
        expect(NaturalDateParsing::interpret_date(text, released)).to eql(answer)
      end
    end
    
    context "Colloquial example 3" do
      text = "August 25, 2013, I met So-and-So"
      released = Date.parse("July 6, 2016")
      answer = [Date.parse("August 25, 2013")]
      
      it "correctly grabs the date" do
        expect(NaturalDateParsing::interpret_date(text, released)).to eql(answer)
      end
    end
    
    context "Colloquial example 4" do
      text = "Quincy Jones (producer of Thriller) and Michael Caine (veteran " +
      "British actor) were both born on the same day and the same hour on March " +
      "14, 1933. They are still friends to this day."
      released = Date.parse("July 6, 2016")
      answer = [Date.parse("March 14, 1933")]
      
      it "correctly grabs the date" do
        expect(NaturalDateParsing::interpret_date(text, released)).to eql(answer)
      end
    end
    
    context "Colloquial example 5" do
      text = "Two days ago (July 4, 2016) was the 190th death anniversary of " +
      "the second and third US Presidents: John Adams and Thomas Jefferson, who died 5 hours apart."
      released = Date.parse("July 6, 2016")
      answer = [Date.parse("July 4, 2016")]
      
      it "correctly grabs the date" do
        expect(NaturalDateParsing::interpret_date(text, released)).to eql(answer)
      end
    end
    
    context "Colloquial example 6" do
      text = "On October 3rd So-and-So asked me what day it was"
      released = Date.parse("July 6, 2016")
      answer = [Date.parse("October 3, 2016")]
      
      it "correctly grabs the date" do
        expect(NaturalDateParsing::interpret_date(text, released)).to eql(answer)
      end
    end
    
    context "Colloquial example 7" do
      text = "Henry and Hanke created a calendar that causes each day to fall " +
      "on the same day of the week every year. They recommend its " +
      "implementation on January 1, 2018, a Monday."
      released = Date.parse("July 6, 2016")
      answer = [Date.parse("January 1, 2018"),
                Date.parse("July 4, 2016")] # Reconsider
      
      it "correctly grabs the date" do
        expect(NaturalDateParsing::interpret_date(text, released)).to eql(answer)
      end
    end
    
    context "Colloquial example 8" do
      text = "Beyoncé Giselle Knowles-Carter was born on September 4, 1981."
      released = Date.parse("July 6, 2016")
      answer = [Date.parse("September 4, 1981")]
      
      it "correctly grabs the date" do
        expect(NaturalDateParsing::interpret_date(text, released)).to eql(answer)
      end
    end
    
    context "Colloquial example 9" do
      text = "The first time I asked someone on a date, I was in Iowa, it was a " +
      "winterly mid-month January, we were to go to finding nemo, I was 9, and " +
      "although she was interested, her parents said no."
      released = Date.parse("July 6, 2016")
      answer = [Date.parse("January 1st, 2016")]
      
      it "correctly grabs the date" do
        expect(NaturalDateParsing::interpret_date(text, released)).to eql(answer)
      end
    end
    
    context "Colloquial example 10" do
      text = "You ate 10 dates from a crate of dates that were picked on June " +
      "8th from a date tree that was cultivated one score and three years ago. " +
      "Good luck parsing through the antics of my semantics."
      released = Date.parse("July 6, 2016")
      answer = [Date.parse("June 8, 2016")]
      
      it "correctly grabs the date" do
        expect(NaturalDateParsing::interpret_date(text, released)).to eql(answer)
      end
    end
    
  end
end