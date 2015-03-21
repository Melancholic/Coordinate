class Car < ActiveRecord::Base
	has_one :api_token, dependent: :destroy;
	belongs_to :user, inverse_of: :cars;
	before_create do 
		self.tracker_uuid=SecureRandom.hex(4);
		self.build_api_token()
	end
end
