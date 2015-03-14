class Api::V1::SessionsController < ApplicationController
	#skip_before_filter :verify_authenticity_token, :only => :login
	protect_from_forgery unless: -> { request.format.json? }
	def login
		json=JSON.parse(request.raw_post)
		if(json)
			user=User.where(auth_hash: json['logdata']).first
			if(user && json['uuid'])
				@tracker=user.trackers.where(uuid:json['uuid']).first
				if(@tracker)
					@tracker.generate_api_token
					render status: 200, json: @tracker.to_json
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

end
