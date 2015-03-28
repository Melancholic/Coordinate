class Maps::TracksController <  Maps::JsonController
	include Maps::TracksHelper;
	before_filter :correct_param
	def index
		@car=Car.find_by_id(params[:car]);
		render status: 200, :json => { :success => true, tracks: @car.tracks , :info => "ok!"}
	end
end
