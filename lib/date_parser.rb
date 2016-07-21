require_relative 'date_parser/natural_date_parsing'
require_relative 'date_parser/utils'

module DateParser
  
  # Public: Parse the text and return interpreted dates and times.
  #
  # txt  - The String to be duplicated.
  # unique - Boolean flag. Should we filter out duplicate dates?
  #
  # Returns an array of Date
  # From a Daily Message, grab date in the natural message, if possible.
  # Otherwise, default to my provided date.
  
  ## Maybe also want a default date?
  def DateParser.parse(txt, unique = false, default_date = nil)
    txt = Utils::clean_str(txt)
    
    interpreted_dates = NaturalDateParsing::interpret_date(txt, Date.today)
    
    if unique
      interpreted_dates.uniq!
    end
    
    if interpreted_dates.nil?
      interpreted_dates = default_date
    end
    
    return interpreted_dates
  end
  
  def DateParser.get_first_date(text)
    txt = Utils::clean_str(txt)
    
    interpreted_dates = NaturalDateParsing::interpret_date
  end
end