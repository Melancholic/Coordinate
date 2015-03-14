class Car < ActiveRecord::Base
	has_one :tracker,  dependent: :destroy ;
	belongs_to :user
	before_save do 
		self.build_tracker(user: self.user)
	end
end
