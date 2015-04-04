class Maps::LocationsController <  Maps::JsonController
	include Maps::LocationsHelper;
	before_action :correct_param, except: [:show];
	before_action :correct_param_for_show, only: [:show];
	def index
		@tracks=params[:tracks].map{|x| Track.find_by_id(x.to_i)}.compact;
		@locs=@tracks.map{|x| x.track_locations};
		render status: 200, :json => { :success => true, locations: @locs , :info => "ok!"}
	end

	def show
		@loc=TrackLocation.find(params[:id]);
		res={latitude: @loc.latitude,
			longitude: @loc.longitude,
			speed: @loc.speed.round,
			time: @loc.time,
			address: (@loc.address)? @loc.address : '???',
			dur_time: TimeDifference.between(@loc.time , @loc.track.start_time ).in_minutes,
			distance: (@loc.distance)? @loc.distance.round(3) : '???' #TODO !
		}
		render status: 200, :json => { :success => true, location: res , :info => "ok!"}
	end
end
