class Api::V1::GeodataController < Api::V1::BaseController
	before_action :check_token
	before_action :check_data
	protect_from_forgery unless: -> { request.format.json? }

	# CURL test 
	# curl  -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Token <Token>" -X POST -d '{"longitude": "0", "latitude": "0", "speed":1, "time":'$(date "+%s%3N")'}'  localhost:3000/api/v1/geodata/recive
	def recive
		new_loc_time = convert_time(params[:time]);
		@car = Car.find(ApiToken.find_by(token: get_token()).car_id)
		@cur_track = find_track(@car, params);
		begin
			@cur_track.create_location!({longitude:params[:longitude],latitude:params[:latitude],	speed:params[:speed]*3.6 ,accuracy:params[:accuracy], time:convert_time(params[:time])});
			logger.debug("Location has been saved.")
			render status: 200, :json => { :success => true, :info => "New location saved.", clear: true} 
		rescue ActiveRecord::RecordNotUnique => x
			logger.info("Location alredy exist.");
			logger.error(x.to_s)
			render status: 200, :json => { :success => true, :info => "Location alredy exist.", clear: true}
		end

	end


private

	def find_track(car,params={})
		time_int = convert_time(params[:time])
		#1
		track = car.tracks.first;
		#<nothing>X
		if ( track.nil? )
			return car.create_track(start_time: time_int); #+
		#-----  >15min X
		elsif ( time_int > track.last_time )
			if ( TimeDifference.between( track.last_time, time_int).in_minutes > Track.time_interval )
				track.update_attributes(stop_time: track.last_time);
				logger.debug("Location include in new track")
				return car.create_track(start_time: time_int);
			else
				logger.debug("Location include in last track")
				return track;
			end
		end
		#2
		track_nxt = car.tracks.where(start_time: time_int .. time_int + Track.time_interval.minute).last;
		track_prd = car.tracks.where(stop_time: time_int - Track.time_interval.minute .. time_int).first;
		if ( track_nxt.nil? && track_prd.nil? )
			#---->15min----- X ----->15min------(middle)
			outer_tracks = car.tracks.where("(:time BETWEEN start_time AND stop_time) OR (:time >= start_time AND stop_time IS NULL)", time: time_int)
			outer_track = outer_tracks.last;
			unless ( outer_track.nil? )
				outer_tracks.each do |x|
					if (outer_track != x)
						outer_track.merge!(x)
					end
				end
				logger.debug("location include in middle track")
				return outer_track;
			end
			#--- >15min X >15min ---
			return car.create_track(start_time: time_int);
		elsif ( !track_nxt.nil? && !track_prd.nil? )
			logger.debug("Track need merge")
			#--- <15min X <15min ---  (merge 2 path)
			if (track_nxt.track_locations.count > track_prd.track_locations.count )
				track_nxt.merge!(track_prd);
				track = track_nxt;
				logger.debug("Track merged with next")
			else
				track_prd.merge!(track_nxt);
				track = track_prd;
				logger.debug("Track merged with pred")
			end
			return track;
		elsif ( !track_nxt.nil? && track_prd.nil? )
			#--- <15min X  ..... 
			logger.debug("location include in next track")
			return track_nxt;
		elsif ( track_nxt.nil? && !track_prd.nil? )
			#.... X <15min --- 
			logger.debug("location include in pred track")
			return track_prd;
		end
	end
	
	def loc_params

	end

	def convert_time(ms)
		#Time.at(1427021993900/1000).utc
		return Time.at(ms/1000).utc
	end
	def check_data
		unless  (params.has_key?(:longitude)&& params.has_key?(:latitude)&& params.has_key?(:speed) && params.has_key?(:time))
			render status: :bad_request, :json => { :success => false, :info => "Required parameters not present: longitude, latitude, speed, time", clear: true} 
		end
		if (params[:speed].to_f == 0)
			render status: :bad_request, :json => { :success => false, :info => "Speed can't be zero!", clear: true} 
		end
	end
end
