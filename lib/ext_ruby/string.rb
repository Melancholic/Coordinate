class String
  def capitalize 
    self.mb_chars.capitalize.to_s
  end
  def initial
    return '' if self.empty?;
    self[0,1].capitalize+".";
  end
end
