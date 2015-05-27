#rand_int(60, 75)
# => 61
#rand_price(10, 100)
# => 43.84
#rand_time(2.days.ago)
# => Mon Mar 08 21:11:56 -0800 2010
class Rand
    def self.int(from, to)
      in_range(from, to).to_i
    end

    def self.price(from, to)
      in_range(from, to).round(2)
    end

    def self.time(from, to=Time.now)
      Time.at(in_range(from.to_f, to.to_f))
    end

    def self.in_range(from, to)
      rand * (to - from) + from
    end

end