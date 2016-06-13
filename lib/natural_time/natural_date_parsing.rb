module NaturalDateParsing
    # Gets an array of possible dates for a message
  # @param released is the date the message was initially sent out.
  # @param unique is a flag that signals whether we want to return unique dates only
  def NaturalDateParsing.interpret_date(msg, released=Date.current.in_time_zone, unique=true)
    possible_dates = []
    msg = msg.split(" ").map{|x| x.strip}
    for i in 1..(msg.length - 1)
      proposed_date_1 = interpret_phrase_as_date(msg[(i-1)..i], released)
      proposed_date_2 = interpret_phrase_as_date([msg[i]], released)
      
      if !proposed_date_1.nil?
        possible_dates << proposed_date_1
      end
      
      if !proposed_date_2.nil?
        possible_dates << proposed_date_2
      end
    end
    
    if unique
      possible_dates = possible_dates.uniq
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
  def NaturalDateParsing.interpret_phrase_as_date(str, released=Date.current.in_time_zone)
    if str.size == 1
      # If the string is size 1, we assume it refers to a day of the week, or
      # something of the form XX/XX
      days = ['mon', 'tue', 'wed', 'thur', 'fri', 'sat', 'sun',
              'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday',
              'sunday',
              'tues']
      relative_days = ['today', 'tomorrow', 'tonight']
      str = str[0]  # We need to unwrap the singleton array.
      if days.include? str
        proposed_date = Date.parse(str)
        tentative_day = proposed_date.day
        
        # If the tentative_day is less than the current day, we assume it takes
        # place next week.
        days_in_week = 7
        proposed_date = (tentative_day < released.day) ? proposed_date + days_in_week :
                                                         proposed_date
        
        return proposed_date
      end
      
      if relative_days.include? str
        if str == 'today' || str == 'tonight'
          return released
        else
          tomorrow = 1
          return released + tomorrow
        end
      end
      
      if str.include? '/'
        # In this case, we assume the string is of the form XX/XX
        samp = str.split('/')
        month = samp[0].to_i
        day = samp[1].to_i
        
        if month > 0 && month <= 12 && day > 0 && day <= 31
          # TODO: IMPROVE EXCEPTION HANDLING.
          # bolted exception handling.
          begin
            return Date.parse(str)
          rescue ArgumentError
            return nil
          end
        end
      end
      
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
end