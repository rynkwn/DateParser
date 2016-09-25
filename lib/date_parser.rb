require 'date'

require_relative 'date_parser/natural_date_parsing'

# DateParser is the main interface between the user and the parser
#
# == Methods
#
# <b>parse(txt, options)</b>: Parse a block of text and return an array of the parsed
# dates as Date objects.
#

module DateParser
  
  # Parses a text object and returns an array of parsed dates.
  #
  # ==== Attributes
  #
  # * +txt+ - The text to parse.
  #
  # * +creation_date+ - A Date object of when the text was created or released. 
  #   Defaults to nil, but if provided can make returned dates more accurate.
  #   This is intentionally checked to be a Date object, as other data types
  #   may cause unforeseen behavior.
  #
  # ==== Options
  #
  # * +:unique+ - Return only unique Date objects. Defaults to false
  #
  # * +:nil_date+ - A date to return if no dates are parsed. Defaults to nil.
  #
  # * +:parse_single_years+ - Parse single ints as years. Defaults to false.
  #
  # * +:parse_ambiguous_dates+ - Some phrases are not necessarily dates depending
  #   on context. For example "1st" may not refer to 
  #   the 1st of a month. This option toggles whether or not those
  #   phrases are considered dates. Defaults to true.
  #
  # ==== Examples
  #
  #    text = "Henry and Hanke created a calendar that causes each day to fall " +
  #           "on the same day of the week every year. They recommend its " +
  #           "implementation on January 1, 2018, a Monday."
  #    creation_date = Date.parse("July 6, 2016")
  #
  #    DateParser::parse(text, creation_date)
  #        #=> [#<Date: 2018-01-01 ((2458120j,0s,0n),+0s,2299161j)>, 
  #             #<Date: 2016-07-11 ((2457581j,0s,0n),+0s,2299161j)>]
  #
  #    ######################################
  #    ##
  #    ## Option Examples:
  #    ##
  #
  #    text = "Sunday, Sunday, Sunday!"
  #    DateParser::parse(text, nil, unique: false)
  #        #=> [#<Date: 2016-07-24 ((2457594j,0s,0n),+0s,2299161j)>, 
  #             #<Date: 2016-07-24 ((2457594j,0s,0n),+0s,2299161j)>, 
  #             #<Date: 2016-07-24 ((2457594j,0s,0n),+0s,2299161j)>]
  #
  #    DateParser::parse(text, nil unique: true)
  #        #=> [#<Date: 2016-07-24 ((2457594j,0s,0n),+0s,2299161j)>]
  #
  #    DateParser::parse("No dates here", nil)
  #        #=> []
  #
  #    DateParser::parse("No dates here", nil, nil_date: Date.parse("Jan 1 2012"))
  #        #=> [#<Date: 2012-01-01 ((2455928j,0s,0n),+0s,2299161j)>]
  #
  #    creation_date = Date.parse("July 15, 2016")
  #    DateParser::parse("He was 1st!", creation_date)
  #        #=> [#<Date: 2016-07-01 ((2457571j,0s,0n),+0s,2299161j)>]
  #
  #    DateParser::parse("He was 1st!", creation_date, parse_ambiguous_dates: false)
  #        #=> []
  #
  def DateParser.parse(txt, creation_date = nil, opts = {})
    unique = opts[:unique].nil? ? false : opts[:unique]
    nil_date = opts[:nil_date].nil? ? nil : opts[:nil_date]
    parse_single_years = opts[:parse_single_years].nil? ? false : opts[:parse_single_years]
    parse_ambiguous_dates = opts[:parse_ambiguous_dates].nil? ? true : opts[:parse_ambiguous_dates]
    
    if ! Utils::descended_from?(creation_date, Date)
      raise ArgumentError, "creation_date must be a descendent of the Date class. " +
                           "(Preferably Date or DateTime) " +
                           "Otherwise, ambiguous behavior may result."
    end
    
    interpreted_dates = NaturalDateParsing::interpret_date(txt, 
                                                           creation_date, 
                                                           parse_single_years,
                                                           parse_ambiguous_dates)
    
    if unique
      interpreted_dates.uniq!
    end
    
    if interpreted_dates.empty?
      interpreted_dates = [nil_date].flatten
    end
    
    # Possibility of getting [nil]
    interpreted_dates.delete(nil)
    
    return interpreted_dates
  end
end