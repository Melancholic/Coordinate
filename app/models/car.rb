class Car < ActiveRecord::Base
	has_one :tracker, inverse_of: :car;
	belongs_to :user, inverse_of: :cars;
	before_save do 
		self.build_tracker(user: self.user)
	end
end
