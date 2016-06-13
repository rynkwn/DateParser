module NaturalTime
  
  
  # Public: Parse the text and return interpreted dates and times.
  #
  # txt  - The String to be duplicated.
  # default_date - The Integer number of times to duplicate the text.
  # unique - Boolean flag. Should we filter out duplicate dates?
  #
  # Returns an array of Date
  # From a Daily Message, grab date in the natural message, if possible.
  # Otherwise, default to my provided date.
  def NaturalTime.parse(txt, default_date=nil, unique=false)
    msg = txt.downcase.gsub(/[^a-z0-9\s\/]/i, '')
    
    date_parse = Proc.new{|x| Date.parse(x)}
    
    if !contemporary_date.nil?
      possible_dates =  dm_interpret_date(msg, contemporary_date, true)
      last_mentioned_date = possible_dates.last
      if(last_mentioned_date.nil?)
        return contemporary_date
      else
        return last_mentioned_date
      end
    end
    
    # We return this iff it's not a normally formatted message. In which case
    # it's most likely a category. I.e., === SOMETHING ===
    return []
  end
  
  
  
  # For a given message, return what time (or range of times) the message refers to.
  # @param message a daily message.
  def DailyMessengerUtils.dm_get_time(message)
    
    if !message.include? "==="
      #msg = get_body(message)
      msg = message.downcase.gsub(/[^a-z0-9\s\/:-]/i, '')
      msg = msg.split("-").map{|x| x.strip}.join("-")  # Cleans up instances like '11 -12'
      
      msg = dm_trim_for_time(msg)
      return dm_parse_times(msg, true)
    end
    
    # We return this if it's a category, which we determine by the presence of "==="
    return []
  end
  
  # For a given message, remove all words that either do not contain a number,
  # or are not preceded by a number.
  # @return An array of words that satisfy the above conditions.
  def DailyMessengerUtils.dm_trim_for_time(msg)
    msg = msg.split(" ")
    
    words_of_interest = []
    max_expected_valid_chars = 14  # Ex: 12:20-12:45pm
    
    # Try to get the hour from some String, and convert to int.
    # We assume that it makes sense whenever we do this.
    determine_hour = Proc.new {|time|
      if time.include? ":"
        time.split(":")[0].to_i  # With a format like 2:20, get the first half.
      else
        time.to_i
      end
    }
    
    # Determine whether a time should be PM or AM.
    determine_suffix = Proc.new {|time|
      if (time.include? "am") || (time.include? "pm")
        time
      else
        guessed_hour = determine_hour.call(time)
        if guessed_hour <= 9 || guessed_hour == 12
          # At certain hours, we can usually assume it takes place in the
          # afternoon or evening.
          time + "pm"
        elsif guessed_hour <= 12  # Should be a non-military hour.
          time + "am"
        else
          time
        end
      end
    }
    
    for i in 1..(msg.length - 1)
      if Stringutils::has_digit(msg[i]) && msg[i].length < max_expected_valid_chars
        word = msg[i]
        
        # If word is of the pattern "1-2pm", we want to only catch "1"
        if word.include? "-"
          puts word
          substrings = word.split("-")
          if Stringutils::is_time(substrings[0]) && Stringutils::is_time(substrings[1])
            word = substrings[0]
            words_of_interest << determine_suffix.call(substrings[1])
          end
        end
        
        word = determine_suffix.call(word)
        words_of_interest << word
        
        if i < msg.length - 1
          words_of_interest << (word + " " + msg[i+1])
        end
      end
    end
    
    return words_of_interest
  end
  
  
  # Looks at str and tries to determine if it's a time.
  # Cases to handle:
  # 1:10
  # 6 PM
  # 1:10-2:00 pm
  # 6-7pm
  # 1-1:45 pm
  # 8 p.m.
  # 12:20-12:45pm
  # @param trimmed_str A trimmed array of words.
  # @param start_end If true, returns a start and end time if reasonably certain.
  # In practice, we check to see if we find only two times.
  # @param all If true, return all filtered times.
  # @return An array of Time objects.
  def DailyMessengerUtils.dm_parse_times(trimmed_str, start_end=false, all=false)
    times = trimmed_str.map{|time|
      begin
        Time.parse(time, Time.current.in_time_zone.midnight())
      rescue ArgumentError  # Usually "argument out of range" or "no time information"
      end
    }
    
    times = times.reject{|time| time.nil? || Date.current > time || (Date.current + 1) < time }
    times = times.uniq
    times = times.sort
    if start_end && times.size == 2
        return times
    end
    
    times = all ? times : [times[0]]
    return times
  end
end