require_relative 'date_parser/natural_date_parsing'
require_relative 'date_parser/utils'


# DateParser is the main interface between the user and the parser
#
# == Methods
#
# *parse(txt, options)*: Parse a block of text and return an array of the parsed
# dates as Date objects.
#
# == Examples:
#
# 
#

module DateParser
  
  # Parses a text object and returns an array of parsed dates.
  #
  # ==== Attributes
  #
  # * +txt+ - The text to parse.
  # * +creation_date+ - The date the text was created or released. Defaults to nil,
  # but if provided can make returned dates more accurate.
  #
  # ==== Options
  #
  # * +:unique+ - Return only unique Date objects. Defaults to false
  # * +:nil_date+ - A date to return if no dates are parsed. Defaults to nil.
  #
  # ==== Examples
  #
  #    
  #    base.method_name("Example", "more")
  def DateParser.parse(txt, creation_date = nil, opts = {})
    unique = opts[:unique] || false
    nil_date = opts[:default_date] || nil
    
    interpreted_dates = NaturalDateParsing::interpret_date(txt, Date.today)
    
    if unique
      interpreted_dates.uniq!
    end
    
    if interpreted_dates.nil?
      interpreted_dates = default_date
    end
    
    return interpreted_dates
  end
end