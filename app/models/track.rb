class Track < ActiveRecord::Base
	belongs_to :car;
	has_many :track_locations, -> { order(time: :asc) }, dependent: :destroy ;
	default_scope -> { order(:stop_time => :desc) }
	def create_location(args)
		self.track_locations.create(args)
	end

	def distance
		self.track_locations.last.distance;
	end
end
