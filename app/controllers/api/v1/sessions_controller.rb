class Api::V1::SessionsController < ApplicationController
	#skip_before_filter :verify_authenticity_token, :only => :login
	before_filter :restrict_access, except:[:login]
	protect_from_forgery unless: -> { request.format.json? }

	def login
		json=JSON.parse(request.raw_post)
		logger.info(json.to_s);
		if(json)
			user=User.where(auth_hash: json['logdata']).first
			if(user && json['uuid'])
				@tracker=user.trackers.where(uuid:json['uuid']).first
				if(@tracker)
					@tracker.generate_api_token
					render status: 200, json:{success: true, data:@tracker,info:"Log in has been success"}
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

	def hello
		render status:200, json:{status:'ok',data:'hello'}
	end

protected
	def restrict_access
  		authenticate_or_request_with_http_token do |token, options|
  			logger.info("Connected with #{token} by #{request.remote_ip}!");
    		Tracker.exists?(api_token: token)
  		end
	end
end
