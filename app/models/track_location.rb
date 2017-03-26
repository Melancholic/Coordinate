class TrackLocation < Location
   self.table_name = 'locations'
  validates :speed, presence: true
	validates :time, presence: true 
	validates :distance, presence: true 
	belongs_to :track
	default_scope -> { order(time: :asc, id: :asc) }

	before_validation do
		pred=self.track.track_locations.where('time < ?', self.time).last;
		if pred && pred.distance
			self.distance=pred.distance;
			self.distance||=0;
			self.distance+=Geocoder::Calculations.distance_between(self,pred);
		else
			self.distance=0;
		end
	end
	after_save do
		self.track.update_attributes(start_time: self.time) if 
			self.track.start_time.nil? || 
			(self.time < self.track.start_time)
		self.track.update_attributes(stop_time: self.time) if 
			!self.track.stop_time.nil? && 
			(self.time > self.track.stop_time)
	end
end
