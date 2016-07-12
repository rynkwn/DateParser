require_relative 'date_utils'
require_relative "utils"

module NaturalDateParsing
  
  SINGLE_DAYS = [
                 'mon', 'tue', 'wed', 'thur', 'fri', 'sat', 'sun',
                 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 
                 'saturday', 'sunday', 'tues'
                ]
                
  RELATIVE_DAYS = ['today', 'tomorrow', 'tonight', 'yesterday']
  
  MONTH = [
           'jan', 'feb', 'mar', 'may', 'june', 'july', 'aug', 'sept', 'oct',
           'nov', 'dec',
           'january', 'february', 'march', 'april', 'august', 'september',
           'october', 'november', 'december'
          ]
          
  NUMERIC_DAY = [
                 ('1'..'31').to_a, 
                 '1st', '2nd', '3rd', '4th', '5th', '6th', '7th', '8th', '9th', 
                 '10th', '11th', '12th', '13th', '14th', '15th', '16th', '17th', 
                 '18th', '19th', '20th', '21st', '22nd', '23rd','24th', '25th', 
                 '26th', '27th', '28th', '29th', '30th', '31st'
                ].flatten
  
  
  
  # Gets an array of possible dates for a message
  # @param released is the date the message was initially sent out.
  # @param unique is a flag that signals whether we want to return unique dates only
  def NaturalDateParsing.interpret_date(text, released = nil)
    possible_dates = []
    text = Utils::clean_str(text)
    words = text.split(" ").map{|x| x.strip}
    
    # We use the while loop, as apparently there are cases where we try to subset
    # words despite the value of i being >= words.length - 3
    # TODO: Figure out why the above happens. Preferably return to for loop.
    
    i = 0
    
    while (i <= words.length - 3) do
      subset_words = words[i..(i+2)]
      
      proposed_date = parse_three_words(subset_words, released)
      
      if(! proposed_date.nil?)
        possible_dates << proposed_date
        words = words - subset_words
      end
      
      i += 1
    end
    
    i = 0
    
    while (i <= words.length - 2) do
      subset_words = words[i..(i+1)]
      proposed_date = parse_two_words(subset_words, released)
      
      if(! proposed_date.nil?)
        possible_dates << proposed_date
        words = words - subset_words
      end
      
      i += 1
    end
    
    i = 0
    
    while (i <= words.length - 1) do
      subset_words = words[i]
      
      proposed_date = parse_one_word(subset_words, released)
      
      if(! proposed_date.nil?)
        possible_dates << proposed_date
        words = words - [subset_words]
      end
      
      i += 1
    end
    
    return possible_dates
  end
  
  def NaturalDateParsing.parse_one_word(word, released = nil)
    # If the string is size 1, we assume it refers to a day of the week, or
    # something of the form XX/XX
    
    if SINGLE_DAYS.include? word
      proposed_date = Date.parse(word)
      tentative_day = proposed_date.day
      
      # If we have the released date, we can try to be a little smarter
      if(! released.nil?)
        # If the tentative_day is less than the current day, we assume it takes
        # place next week.
        days_in_week = 7
        proposed_date = (tentative_day < released.day) ? proposed_date + days_in_week :
                                                         proposed_date
        
        return proposed_date
      end
    end
    
    if RELATIVE_DAYS.include? word
      if word == 'today' || word == 'tonight'
        if released.nil?
          return Date.today
        else
          return released
        end
      elsif word == 'yesterday'
        if released.nil?
          return Date.today - 1
        else
          return released - 1
        end
      else
        tomorrow = 1
        return released + tomorrow ## Double check this.
      end
    end
    
    if word.include? '/'
      # In this case, we assume the string is of the form XX/XX
      return DateUtils::parse_slash_date(word, released)
    end
    
    if NUMERIC_DAY.include? word
      return DateUtils::parse_numeric(word, released)
    end
  end
  
  # Now we assume it refers to a month day, or MON ## combination.
  def NaturalDateParsing.parse_two_words(words, released = nil)
    if MONTH.include?(words[0]) && NUMERIC_DAY.include?(words[1])
      return Date.parse(words.join(" "))
    end
  end
  
  ## We assume it's the following format: MONTH NUM, YEAR
  def NaturalDateParsing.parse_three_words(words, released = nil)
    if MONTH.include?(words[0]) && NUMERIC_DAY.include?(words[1]) && Utils::is_int?(words[2])
      return Date.parse(words.join(" "))
    end
  end
end