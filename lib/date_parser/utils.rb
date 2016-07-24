module Utils
  
  # Determine whether or not a String is a base 10 integer.
  def Utils.is_int?(str)
    str.to_i.to_s == str
  end
  
  # Removes punctuation.
  def Utils.clean_out_punctuation(str)
    str.gsub(/[^a-z0-9\s\/]/i, '')
  end
  
  # Removes punctuation and downcases the str.
  def Utils.clean_str(str)
    clean_out_punctuation(str).downcase
  end
  
  # Performs delete_at for a range of integers
  def Utils.delete_at_indices(array, range)
    for i in range do
      array.delete_at(i)
    end
    
    return array
  end
end