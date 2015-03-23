class Api::V1::GeodataController < Api::V1::BaseController
	before_filter :check_token
	before_filter :check_data
	protect_from_forgery unless: -> { request.format.json? }
	def recive
		@car=Car.find(ApiToken.find_by(token:get_token()).car_id)
		track=Track.where(car_id:@car.id).order(start_time: :desc).first
		@cur_track=track
		if track.nil?
			@cur_track=@car.create_track(start_time: convert_time(params[:time]))
			logger.debug("Cur track is create via tracks is nil")
		else
			@last_loc=track.track_locations.order(time: :desc).first
			if(@last_loc.nil?)

				if(TimeDifference.between(convert_time(params[:time]),track.start_time).in_minutes > 15)
					track.destroy;
					@cur_track=@car.create_track(start_time: convert_time(params[:time]));
					logger.debug("New Track is created after destroy old via old Track is empty");
				else
					track.update_attributes(start_time: convert_time(params[:time]))
					@cur_track=track;
				end
			elsif (TimeDifference.between(@last_loc.time,convert_time(params[:time])).in_minutes > 15 )
				track.update_attributes(stop_time: @last_loc.time);
				@cur_track=@car.create_track(start_time: convert_time(params[:time]))	
				logger.debug("Cur track is create via tracks is ended")				
			end
		end
		if(@last_loc && params[:speed]==0)
			s=(@last_loc.distance_from ([params[:latitude],params[:longitude]]))*1000
			t=TimeDifference.between(@last_loc.time, convert_time(params[:time])).in_seconds
			params[:speed]=(s/t)*3.6 if t!=0;
			logger.debug("s=#{s}")
			logger.debug("t=#{t}")	
			logger.debug("v=#{params[:speed]}")
		end
		@cur_track.create_location({longitude:params[:longitude],latitude:params[:latitude],	speed:params[:speed],accuracy:params[:accuracy], time:convert_time(params[:time])});
		logger.debug("Location has been saved!")
		render status: 200, :json => { :success => true, :info => "ok"} 
	end


private
	
	def loc_params

	end

	def convert_time(ms)
		return Time.at(ms/1000).utc
	end
	def check_data
		#Time.at(1427021993900/1000).utc
		unless  (params.has_key?(:longitude)&& params.has_key?(:latitude)&& params.has_key?(:speed) && params.has_key?(:time))
			render status: :bad_request, :json => { :success => false, :info => "Uncorrect data!"} 
		end
	end
end
