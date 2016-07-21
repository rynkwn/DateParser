require_relative 'date_parser/natural_date_parsing'
require_relative 'date_parser/utils'


# DateParser is the main interface between the user and the parser
#
# == Methods
#
# *parse(txt, options)*: Parse a block of text and return an array of the parsed
# dates as Date objects.
#
# *get_first_date(txt): Parse a block of text but stop and return the first parsed
# date found.
#

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
  
  # 
  
  # Parses a text object and returns an array of parsed dates.
  #
  # ==== Attributes
  #
  # * +txt+ - 
  # * +txt+ - 
  # * +txt+ - 
  #
  # ==== Options
  #
  # You may which to break out options as a separate item since there maybe
  # multiple items. Note options are prefixed with a colon, denoting them
  # as a 
  #
  # * +:conditions+ - An SQL fragment like "administrator = 1"
  # * +:order+ - An SQL fragment like "created_at DESC, name".
  # * +:group+ - An attribute name by which the result should be grouped
  # * +:limit+ - An integer determining the limit on the number of rows that should be returned.
  # * +:offset+ - An integer determining the offset from where the rows should be fetched.
  # * +:joins+ - Either an SQL fragment for additional joins like "LEFT JOIN comments ON comments.post_id = id" (rarely needed)
  #
  # ==== Examples
  # 
  # Illustrate the behaviour of the method using examples. Indent examples:
  #
  #    base = Base.new("Example String")
  #    base.method_name("Example", "more")
  def DateParser.parse(txt, unique = false, default_date = nil)
    
    interpreted_dates = NaturalDateParsing::interpret_date(txt, Date.today)
    
    if unique
      interpreted_dates.uniq!
    end
    
    if interpreted_dates.nil?
      interpreted_dates = default_date
    end
    
    return interpreted_dates
  end
  
  def DateParser.get_first_date(txt)
    return NaturalDateParsing::interpret_first_date(txt)
  end
end