class Api::V1::SessionsController < ApplicationController
	#skip_before_filter :verify_authenticity_token, :only => :login
	before_filter :check_token, except:[:login]
	protect_from_forgery unless: -> { request.format.json? }

	def login
		json=JSON.parse(request.raw_post)
		logger.info(json.to_s);
		if(json)
			user=User.where(auth_hash: json['logdata']).first
			if(user && json['uuid'])
				@car=user.cars.where(tracker_uuid:json['uuid']).first
				if(@car)
					@car.api_token.generate_api_token
					@token=@car.api_token.token
					render status: 200, json:{success: true, data:{api_token: @token} ,info:"Log in has been success"}
				else
					render :status => :bad_request,
						:json => { :success => false,
						:info => "Tracker not founded!" 
					}
				end
			else
				render :status => :bad_request,
					:json => { :success => false,
					:info => "Bad user or uuid!" 
				}
			end
		else
			render :status => :bad_request,
				:json => { :success => false,
				:info => "Bad json!" 
			}
		end
	end

	def logout
  		authenticate_or_request_with_http_token do |token, options|
  			logger.info("Tracker with #{token} from #{request.remote_ip} has been logout!");
    		@token=ApiToken.find_by(token: token);
  		end
  		if(@token)
			@token.generate_api_token
			render :status => 200,
				:json => { :success => true,
				:info => "logout complete!" 
				}
		else
			render :status => bad_request,
				:json => { :success => false,
				:info => "unknow API token!" 
				}
		end
	end

	def hello
		render status:200, json:{status:'ok',data:'hello'}
	end

protected
	def check_token
  		authenticate_or_request_with_http_token do |token, options|
  			logger.info("Connected with #{token} from #{request.remote_ip}!");
    		ApiToken.exists?(token: token)
  		end
	end
end
