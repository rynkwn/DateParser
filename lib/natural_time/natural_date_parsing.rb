require_relative 'utils'

module NaturalDateParsing
  # Gets an array of possible dates for a message
  # @param released is the date the message was initially sent out.
  # @param unique is a flag that signals whether we want to return unique dates only
  def NaturalDateParsing.interpret_date(text, released=nil)
    possible_dates = []
    words = text.split(" ").map{|x| x.strip}
    
    for i in 1..(words.length - 1)
      proposed_date_1 = interpret_phrase_as_date(words[(i-1)..i], released)
      proposed_date_2 = interpret_phrase_as_date([words[i]], released)
      
      if !proposed_date_1.nil?
        possible_dates << proposed_date_1
      end
      
      if !proposed_date_2.nil?
        possible_dates << proposed_date_2
      end
    end
    
    return possible_dates
  end
  
  # Looks at a small phrase and tries to see if it refers to a date. If it is a date
  # we return the appropriate date, formatted.
  # otherwise we return nil.
  # We assume the string is downcased, stripped of any punctuation, and in an array
  # split by spaces.
  # @param str is an array containing 1-2 strings.
  # @param released is the date the message was initially sent out.
  def NaturalDateParsing.interpret_phrase_as_date(str, released=nil)
    if str.size == 1
      parse_one_word(str, released)
    elsif str.size == 2
      # Now we assume it refers to a month day, or MON ## combination.
      month = ['jan', 'feb', 'mar', 'may', 'june', 'july', 'aug', 'sept', 'oct',
               'nov', 'dec',
               'january', 'february', 'march', 'april', 'august', 'september',
               'october', 'november', 'december']
      day = [('1'..'31').to_a, 
             '1st', '2nd', '3rd', '4th', '5th', '6th', '7th', '8th', '9th', '10th',
             '11th', '12th', '13th', '14th', '15th', '16th', '17th', '18th',
             '19th', '20th', '21st', '22nd', '23rd','24th', '25th', '26th',
             '27th', '28th', '29th', '30th', '31st'].flatten
      
      if month.include?(str[0]) && day.include?(str[1])
        return Date.parse(str.join(" "))
      end
    end
    
    return nil
  end
  
  def NaturalDateParsing.parse_one_word(word, released)
    # If the string is size 1, we assume it refers to a day of the week, or
    # something of the form XX/XX
    days = ['mon', 'tue', 'wed', 'thur', 'fri', 'sat', 'sun',
            'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday',
            'sunday',
            'tues']
    relative_days = ['today', 'tomorrow', 'tonight']
    word = word[0]  # We need to unwrap the singleton array.
    if days.include? word
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
    
    if relative_days.include? word
      if word == 'today' || word == 'tonight'
        return released
      else
        tomorrow = 1
        return released + tomorrow
      end
    end
    
    if word.include? '/'
      # In this case, we assume the string is of the form XX/XX
      Utils::parse_slash_date(word)
    end
  end
end