class Maps::TracksController <  Maps::JsonController
	include Maps::TracksHelper;
	before_filter :correct_param
	def index
		@car=Car.find_by_id(params[:car]);

		time_start=(DateTime.parse(params[:start_date]).utc) if params.has_key?(:start_date);
		time_end=(DateTime.parse(params[:end_date]).utc)if params.has_key?(:end_date);
		time_end=time_end.change({ hour: 23, min: 59, sec: 59 }) if time_end;
		if(time_start &&  time_end)
			@tracks=@car.tracks.where(start_time: time_start..time_end);
		elsif(time_start)
			@tracks=@car.tracks.where(['start_time >= ?', time_start]);
		elsif(time_end)
			@tracks=@car.tracks.where(['start_time <= ?', time_end]);
		else
			@tracks=@car.tracks;
		end
		render status: 200, :json => { :success => true, tracks: @tracks , :info => "ok!"}
	end
end
