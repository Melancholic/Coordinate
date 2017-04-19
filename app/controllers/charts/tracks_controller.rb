class Charts::TracksController < JsonApplicationController
    include SimpleCaptcha::ControllerHelpers

    def speed_agg_info
        result = {
            avg: TrackLocation.where(track: current_user.all_tracks).average('speed').to_f.round,
            max: TrackLocation.where(track: current_user.all_tracks).maximum('speed').to_f.round
        }
        do_success(result) 
    end

    def tracks_per_car 
        @cars_with_tracs=current_user.cars.to_a.delete_if{|x| x.tracks.empty?}
        colors=[];
        data = @cars_with_tracs.map do |x| 
          colors.append("##{x.color}");
          [x.title, x.tracks.count*1.0/current_user.all_tracks.count]
      end
      result = {values: data, colors: colors};
      do_success(result)
  end

  def distance_per_car 
    @cars_with_tracs=current_user.cars.with_tracks
    colors = [];
    data = @cars_with_tracs.map do |x| 
      colors.append("##{x.color}");
      distance = TrackLocation.unscoped.where(track: x.tracks).group('track_id').maximum(:distance).values.compact.sum
      [x.title, distance]
  end

  result = {values: data, colors: colors};
  do_success(result)
end

def tracks_per_time 
    data = [];
    data.push(current_user.group_tracks_by_day(:all))
    current_user.cars.with_tracks.limit(10).each do |x|
        data.push(current_user.group_tracks_by_day(x)) 
    end
    do_success(data.compact)
end

def stats_of_track_by_user
    @user = current_user;

    if @user.all_tracks.count > 0
        @days=TimeDifference.between(@user.all_tracks.last.start_time, @user.all_tracks.first.start_time).in_days.round+1;
        @total_tracks=@user.all_tracks.count;
        @total_distance=Track.total_distance_for_user(current_user).round(3);
        @average_distance=(@total_distance/@total_tracks).round(3);
        @cars_with_tracs=current_user.cars.to_a.delete_if{|x| x.tracks.empty?};
        @average_distance_per_car=(@total_distance/@cars_with_tracs.count).round(3);
        @average_distance_per_day=(@total_distance/@days).round(3);
        @favorite_car=@user.cars.max_by{|x| x.tracks.count};
        @average_tracks_per_day=(@total_tracks/@days).round(1);
        @average_tracks_per_car=(@total_tracks/@cars_with_tracs.count).round(1);
        respond_to do |format|
            format.json {render layout: false} # Add this line to you respond_to block
        end
    else 
        do_failure("Tracks is empty!");
    end
end

private
def do_success(data)
    render status: 200, :json => {success: true, data: data} 
end 

def do_failure(msg)
    render :status => :bad_request, :json => {success: false}, info: msg 
end 
end
