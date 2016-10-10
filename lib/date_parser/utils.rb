# Extra utility functions for broader use in the gem.
#
# == Methods
#
# <b>interpret_date(txt, creation_date, parse_single_years)</b>: 
# Return an array of dates from the set of parameters.
#
# We parse in order of decreasing
# strictness. I.e., a very specific phrase like "January 1st, 2013" will be parsed
# before "January 1st," which will be parsed before just "2013". Whenever we
# determine a phrase is part of a date, we remove the phrase after parsing.
# So in the example "January 1st, 2013" we'll return only one date.
#
# If no dates are found, returns an empty array.
#
# <b>parse_one_word(word, creation_date, parse_single_years)</b>: Given a single word,
# a string, tries to return a Date object.
#

# Extra utility functions for broader use in the gem.

module DateParser
  module Utils
    
    # Determine whether or not a String is a base 10 integer.
    def Utils.is_int?(str)
      str.to_i.to_s == str || strong_is_int?(str)
    end
    
    # A more rigorous check to see if the String is an int.
    def Utils.strong_is_int?(str)
      nums = ("0".."9").to_a
      
      for char in str.each_char do
        if ! nums.include? char
          return false
        end
      end
      
      return true
    end
    
    # Removes punctuation.
    def Utils.clean_out_punctuation(str)
      str.gsub(/[^a-z0-9\s\/-]/i, '')
    end
    
    # Removes punctuation and downcases the str.
    def Utils.clean_str(str)
      clean_out_punctuation(str).downcase
    end
    
    # Performs delete_at for a range of integers
    #
    # Assumes that the integers in range are contiguous, and sorted in ascending
    # order.
    def Utils.delete_at_indices(array, range)
      first_val = range.first
      for _ in range do
        array.delete_at(first_val)
      end
      
      return array
    end
    
    # Checks to see if an object is descended from an ancestor (or is the ancestor)
    # nil_accepted is a flag that checks 
    def Utils.descended_from?(obj, ancestor, nil_accepted = true)
      return obj.nil? ? nil_accepted : obj.class.ancestors.include?(ancestor)
    end
  end
end