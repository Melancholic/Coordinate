module Api::V1::SessionsHelper
	def check_token
  		authenticate_or_request_with_http_token do |token, options|
  			logger.info("Connected with #{token} from #{request.remote_ip}!");
    		ApiToken.exists?(token: token)
  		end
	end
end
