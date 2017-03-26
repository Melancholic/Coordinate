class Maps::TracksController <  Maps::JsonController
	include Maps::TracksHelper;
	before_action :correct_param, only:[:index]
	before_action :correct_param_for_info, only:[:info]
	before_action :correct_param_for_info_all, only:[:info_all]
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

	def info
		@track=Track.by_user(current_user).find(params[:track_id]);
		@distance=@track.distance.round(3);
		@duration=@track.duration_humanize
		@avg_speed=@track.track_locations.average(:speed).to_i
		@max_speed=@track.track_locations.maximum(:speed).to_i
		@start_time=@track.start_time.in_time_zone(current_user.time_zone)
		@stop_time = (@track.stop_time.nil?) ? @track.track_locations.last.time : @track.stop_time
		@stop_time=@stop_time.in_time_zone(current_user.time_zone)
		array=TrackLocation.unscoped.where(track: @track).group_by_minute(:time).average(:speed).map{|x,v| {x=>v.to_i} }.delete_if{|x| x.first.second==0}.reduce Hash.new, :merge
		@speeds=array.values
		@times=array.keys.map{|x| x.in_time_zone(current_user.time_zone).strftime("%H:%M")}
		respond_to do |format|
		    format.js {render 'show_info.js'}
  		end
	end
	def info_all
		@tracks=Track.by_user(current_user).where(id:params[:track_ids]);
		@distances=@tracks.to_a.sum{|x| x.distance}.round(3);
		@durations=duration_humanize(@tracks.to_a.sum{|x| x.duration}.round)
		@max_duration=duration_humanize(@tracks.map{|x| x.duration}.max)
		@min_duration=duration_humanize(@tracks.map{|x| x.duration}.min)
		@max_distance=@tracks.map{|x| x.distance}.max.round(3)
		@min_distance=@tracks.map{|x| x.distance}.min.round(3)

		@avg_speed= TrackLocation.where(track: @tracks).average(:speed).to_i
		@max_speed=TrackLocation.where(track: @tracks).maximum(:speed).to_i


		respond_to do |format|
		    format.js {render 'show_info_all.js'}
  		end
	end

end
