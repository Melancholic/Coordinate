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

end
