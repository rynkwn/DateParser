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
          
  NUMERIC_DAY = [('1'..'31').to_a].flatten
                
  SUFFIXED_NUMERIC_DAY = [
                           '1st', '2nd', '3rd', '4th', '5th', '6th', '7th', 
                           '8th', '9th', '10th', '11th', '12th', '13th', '14th', 
                           '15th', '16th', '17th', '18th', '19th', '20th', 
                           '21st', '22nd', '23rd','24th', '25th', 
                           '26th', '27th', '28th', '29th', '30th', '31st'
                         ]
  
  
  
  # Gets an array of possible dates for a message
  # @param released is the date the message was initially sent out.
  # @param unique is a flag that signals whether we want to return unique dates only
  # @param parse_single_years a flag to signal whether we should parse for single years.
  def NaturalDateParsing.interpret_date(text, released = nil, parse_single_years = false)
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
        words = Utils::delete_at_indices(words, i..(i+2))
        i -= 1
      end
      
      i += 1
    end
    
    i = 0
    
    while (i <= words.length - 2) do
      subset_words = words[i..(i+1)]
      proposed_date = parse_two_words(subset_words, released)
      
      if(! proposed_date.nil?)
        possible_dates << proposed_date
        words = Utils::delete_at_indices(words, i..(i+1))
        i -= 1
      end
      
      i += 1
    end
    
    i = 0
    
    while (i <= words.length - 1) do
      subset_words = words[i]
      
      proposed_date = parse_one_word(subset_words, released, parse_single_years)
      
      if(! proposed_date.nil?)
        possible_dates << proposed_date
        words.delete_at(i)
        i -= 1
      end
      
      i += 1
    end
    
    return possible_dates
  end
  
  def NaturalDateParsing.parse_one_word(word, released = nil, parse_single_years = false)
    # If the string is size 1, we assume it refers to a day of the week, or
    # something of the form XX/XX
    
    if SINGLE_DAYS.include? word
      proposed_date = Date.parse(word)
      tentative_day = proposed_date.day
      
      # If we have the released date, we can try to be a little smarter
      if(! released.nil?)
        # If the tentative_day is less than the current day, we assume it takes
        # place next week.
        weeks_to_shift = DateUtils::difference_in_weeks(Date.today, released)
                                                         
        proposed_date = proposed_date - (weeks_to_shift * 7)
        
        # Right now though, it should be within 1 week of accuracy, and always 
        # one week ahead. The solution is pretty simple. If the proposed date 
        # is more than a week ahead of the creation date, then go back one week.
        if proposed_date - released > 7
          proposed_date = proposed_date - 7
        end
        
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
      return DateUtils::slash_date(word, released)
    end
    
    if SUFFIXED_NUMERIC_DAY.include? word
      return DateUtils::numeric(word, released)
    end
    
    if MONTH.include? word
      return DateUtils::default_month(word, released)
    end
    
    # In this case, we assume it's a year!
    if parse_single_years && (Utils::is_int? word)
      return DateUtils::default_year(word)
    end
  end
  
  
  # Now we assume it refers to a month day, or MON ## combination.
  def NaturalDateParsing.parse_two_words(words, released = nil)
    if MONTH.include?(words[0]) && _weak_day?(words[1])
      return DateUtils::month_day(words, released)
    end
  end
  
  
  ## We assume it's the following format: MONTH NUM, YEAR
  def NaturalDateParsing.parse_three_words(words, released = nil)
    if MONTH.include?(words[0]) && _weak_day?(words[1]) && Utils::is_int?(words[2])
      return Date.parse(words.join(" "))
    end
  end
  
  
  private
  
  def NaturalDateParsing._weak_day?(word)
    return (NUMERIC_DAY.include? word) || (SUFFIXED_NUMERIC_DAY.include? word)
  end
end