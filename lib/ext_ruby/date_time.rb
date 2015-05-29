class DateTime
end

class Time


    #full, abbreviation
    def self.humanize (secs)
      words=[[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]];
      words.inject([]){ |s, (count, name)|
        if secs > 0
          secs, n = secs.divmod(count)
          s.unshift n.to_i.to_s.rjust(2,'0')
        end
        s
      }.join(':')
    end
end