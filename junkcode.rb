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
      
    end
    
    return nil
  end