module Utils
  
  # Determine whether or not a String is a base 10 integer.
  def is_int?(str)
    str.to_i.to_s == str
  end
end