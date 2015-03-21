class ApiToken < ActiveRecord::Base
	belongs_to :car

	before_create do
		self.token=ApiToken.encrypt(ApiToken.new_api_token);
	end

	def generate_api_token
	    self.update_attributes(token:ApiToken.encrypt(ApiToken.new_api_token));
	end

private
	def ApiToken.new_api_token
		SecureRandom.urlsafe_base64;
	end
	       
	def ApiToken.encrypt(sometoken)
		Digest::SHA1.hexdigest(sometoken.to_s)
	end

end
