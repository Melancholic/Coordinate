class Car < ActiveRecord::Base
	has_one :api_token, dependent: :destroy;
	belongs_to :user, inverse_of: :cars;
	has_many :tracks, dependent: :destroy;
	before_create do 
		self.tracker_uuid=SecureRandom.hex(4);
		self.build_api_token()
	end

	def create_track(args)
		self.tracks.create(args)
	end
end
