class String
  def is_number?
    true if Float(self) rescue false
  end

  def is_integer?
    self.to_i.to_s == self
  end
end

class Hash
  def keys_to_hashes
    self.each_with_object({}){|(k,v), h| h[k.to_sym] = v}
  end

  def keys_to_strings
    self.each_with_object({}){|(k,v), h| h[k.to_s] = v}
  end
end

class Time
  def self.diff(start_time, end_time)
    seconds_diff = (start_time - end_time).to_i.abs

    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600

    minutes = seconds_diff / 60
    seconds_diff -= minutes * 60

    seconds = seconds_diff

    "#{hours.to_s.rjust(2, '0')}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"
  end
end