class NaturalTime
  def self.hi
    puts "Hello world!"
  end
  
  
  # Public: Parse the text and return interpreted dates and times.
  #
  # txt  - The String to be duplicated.
  # default_date - The Integer number of times to duplicate the text.
  # unique - Boolean flag. Should we filter out duplicate dates?
  #
  # Returns an array of Date
  # From a Daily Message, grab date in the natural message, if possible.
  # Otherwise, default to my provided date.
  def parse(txt, default_date=nil, unique=false)
  end
end