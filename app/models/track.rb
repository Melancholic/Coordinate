class Track < ActiveRecord::Base
	belongs_to :car;
	has_many :track_locations, dependent: :destroy;
end
