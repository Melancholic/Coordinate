class Car < ActiveRecord::Base
	has_one :api_token, dependent: :destroy;
	belongs_to :user, inverse_of: :cars;
	has_many :tracks, dependent: :destroy;
	validates(:title, presence: true, length:{maximum:15,minimum:3});
	validates(:title, uniqueness: {scope: :user_id,
    message: "You already have a car with the same title" });
	validates :color, :color_format => true
	validates :priority, inclusion:{in: 0..10, message: "is not included in 0 .. 10" }
	default_scope -> { order(:priority => :desc, :title =>:asc) }
	before_create do 
		self.color.upcase!
		self.tracker_uuid=SecureRandom.hex(4);
		self.build_api_token()
	end

	def create_track(args)
		self.tracks.create(args)
	end
end
