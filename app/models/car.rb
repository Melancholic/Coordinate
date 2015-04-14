class Car < ActiveRecord::Base
	DescriptionLength=180;
	has_one :api_token, dependent: :destroy;
	belongs_to :user, inverse_of: :cars;
	has_many :tracks, dependent: :destroy;
	belongs_to :image, dependent: :destroy;
	accepts_nested_attributes_for :image, update_only: true, :reject_if => proc { |attributes| attributes['img'].blank? }, :allow_destroy => true
	validates(:title, presence: true, length:{maximum:15,minimum:3});
	validates(:title, uniqueness: {scope: :user_id,
    message: "You already have a car with the same title" });
	validates :color, :color_format => true
	validates :priority, inclusion:{in: 0..10, message: "is not included in 0 .. 10" }
	validates :description, length:{maximum: DescriptionLength ,minimum:3}
	default_scope -> { order(:priority => :desc, :title =>:asc) }


	before_create do 
		self.color.upcase!
		self.tracker_uuid=SecureRandom.hex(4);
		self.build_api_token()
	end

	def create_track(args)
		self.tracks.create(args)
	end

	def img
		self.image.img;
	end
end
