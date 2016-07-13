module DateUtils
  # Parse words of the form XX/XX
  def DateUtils.slash_date(word, released = nil)
    samp = word.split('/')
    month = samp[0].to_i
    day = samp[1].to_i
    
    if month > 0 && month <= 12 && day > 0 && day <= 31
      # TODO: IMPROVE EXCEPTION HANDLING.
      # bolted exception handling.
      begin
        proposed_date = Date.parse(word)
        if(! released.nil?) ## We're sensitive to only years here.
          years_diff = Date.today.year - released.year
          proposed_date = proposed_date << (12 * years_diff)
        end
        return proposed_date
      rescue ArgumentError
        return nil
      end
    end
  end
  
  # We parse a numeric date (1st, 2nd, 3rd, e.t.c.) given a release date
  def DateUtils.numeric(word, released = nil)
    diff_in_months = released.nil? ? 0 : (released.year * 12 + released.month) - 
                                         (Date.today.year * 12 + Date.today.month)
    
    
    begin
      return Date.parse(word) >> diff_in_months
    rescue ArgumentError
      ## If an ArgumentError arises, Date is not convinced it's a date.
      return nil
    end
  end
  
  # Parsing things like "March 4"
  def DateUtils.month_day(words, released = nil)
    proposed_date = Date.parse(words.join(" "))
    
    diff_in_years = released.nil? ? 0 : (released.year - Date.today.year)
    
    return proposed_date >> diff_in_years * 12
  end
  
  # Effectively shifts start date for Date.parse() operations.
  #def DateUtils.shift_start_date(old_date, new_start_date)
    # Parsing a relative day (Sensitive to week, month, year)
    # Parsing a relative month (Sensitive to year)
    
  #end
  
  def DateUtils.default_date(year)
    return Date.parse("Jan 1 " + year)
  end
  
  def DateUtils.suffix(number)
    int = number.to_i
    
    ## Check to see if the least significant digit is 1.
    if int & 1 == 1
      return int.to_s + "st"
    else
      return int.to_s + "th"
    end
  end
end