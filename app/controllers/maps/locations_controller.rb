class Maps::LocationsController <  Maps::JsonController
	include Maps::LocationsHelper;
	before_filter :correct_param
	def index
		@tracks=params[:tracks].map{|x| Track.find_by_id(x.to_i)}.compact;
		@locs=@tracks.map{|x| x.track_locations};
		render status: 200, :json => { :success => true, locations: @locs , :info => "ok!"}
	end
end
