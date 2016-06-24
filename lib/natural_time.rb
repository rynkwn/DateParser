require_relative 'natural_time/natural_date_parsing'
require_relative 'natural_time/utils'

module NaturalTime
  
  # Public: Parse the text and return interpreted dates and times.
  #
  # txt  - The String to be duplicated.
  # unique - Boolean flag. Should we filter out duplicate dates?
  #
  # Returns an array of Date
  # From a Daily Message, grab date in the natural message, if possible.
  # Otherwise, default to my provided date.
  def NaturalTime.parse(txt, unique=false)
    txt = Utils::clean_str(txt)
    
    date_parse = Proc.new{|x| Date.parse(x)}
    
    interpreted_dates = NaturalDateParsing::interpret_Date(txt, Date.today)
    
    if unique
      interpreted_dates.uniq!
    end
    
    
    #if !contemporary_date.nil?
      #possible_dates =  dm_interpret_date(msg, contemporary_date, true)
      #last_mentioned_date = possible_dates.last
      #if(last_mentioned_date.nil?)
        #return contemporary_date
      #else
        #return last_mentioned_date
      #end
    #end
    
    # We return this iff it's not a normally formatted message. In which case
    # it's most likely a category. I.e., === SOMETHING ===
    return interpreted_dates
  end
end