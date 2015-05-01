class Track < ActiveRecord::Base
	belongs_to :car;
	has_many :track_locations, -> { order(time: :asc) }, dependent: :destroy ;
	default_scope -> { order(stop_time: :desc, id: :desc) }
	def create_location(args)
		self.track_locations.create(args)
	end

	def distance
		if(track_locations.empty?)
			0
		else
			self.track_locations.select(:distance).last.distance || 0;
		end
	end

	def duration
		if(track_locations.empty?)
			0;
		else
			TimeDifference.between(self.start_time , self.stop_time || self.track_locations.last.time ).in_minutes
		end
	end

	def duration_humanize
		dur=self.duration()
		case(dur)
		when 0..1
			return "#{(dur*60.0).round()} sec"
		when  1..60
			return "#{(dur).round()} min"
		when 60..1.0/0
			return "#{(dur*1.0/60).round(2)} h"
		else
			return "dur"
		end
	end
end
