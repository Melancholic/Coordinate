class Track < ActiveRecord::Base
	belongs_to :car;
	has_many :track_locations, dependent: :destroy;

	def create_location(args)
		self.track_locations.create(args)
	end
end
