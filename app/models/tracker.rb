class Tracker < ActiveRecord::Base
	belongs_to :user, inverse_of: :trackers;
	belongs_to :car, inverse_of: :tracker; 

  def generate_api_token
    self.update_attributes(api_token:Tracker.encrypt(Tracker.new_api_token));
  end

private

	def Tracker.new_api_token
    	SecureRandom.urlsafe_base64;
	end
	
	def Tracker.encrypt(token)
    	Digest::SHA1.hexdigest(token.to_s)
  	end
  
end
