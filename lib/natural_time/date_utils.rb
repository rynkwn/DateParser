module DateUtils
  # Parse words of the form XX/XX
  def DateUtils.parse_slash_date(word)
    samp = str.split('/')
    month = samp[0].to_i
    day = samp[1].to_i
    
    if month > 0 && month <= 12 && day > 0 && day <= 31
      # TODO: IMPROVE EXCEPTION HANDLING.
      # bolted exception handling.
      begin
        return Date.parse(word)
      rescue ArgumentError
        return nil
      end
    end
  end
end