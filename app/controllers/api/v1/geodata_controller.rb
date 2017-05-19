class Api::V1::GeodataController < Api::V1::BaseController
  before_action :check_token
  before_action :check_data
  protect_from_forgery unless: -> {request.format.json?}

  # CURL test
  # curl  -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Token <Token>" -X POST -d '{"longitude": "0", "latitude": "0", "speed":1, "time":'$(date "+%s%3N")'}'  localhost:3000/api/v1/geodata/recive
  def recive
    new_loc_time = convert_time(params[:time])
    ActiveRecord::Base.transaction do
      @car = Car.find(ApiToken.find_by(token: get_token()).car_id)
      @cur_track = find_track(@car, params)
      begin
        @cur_track.create_location!({longitude: params[:longitude], latitude: params[:latitude], speed: (params[:speed]*3.6).round, accuracy: params[:accuracy], time: convert_time(params[:time])});
        logger.debug("Location has been saved.")
        render status: 200, :json => {:success => true, :info => "New location saved.", clear: true}
      rescue ActiveRecord::RecordNotUnique => x
        logger.info("Location alredy exist.")
        logger.error(x.to_s)
        render status: 200, :json => {:success => true, :info => "Location alredy exist.", clear: true}
      end
    end

  end


  private

  def find_track(car, params={})
    time = convert_time(params[:time])
    result_track = Track.new(car: car)
    potential_tracks = TrackLocation.unscoped.by_car(car)
                           .where(time: time - Track::TIME_INTERVAL .. time + Track::TIME_INTERVAL)
                           .group(:track_id).minimum(:time).keys
    potential_tracks = Track.where(id: potential_tracks).to_a
    # CASE #1
    # *****----<15min----#
    # #----<15min----*****
    if potential_tracks.count == 1
      result_track = potential_tracks.first
      # CASE #2
      # *****----<15min----#----<15min---****
    elsif potential_tracks.count > 1
      result_track = Track.recursive_merge potential_tracks
      # CASE #3
      # Create new track
    else
      result_track.save
    end
    return result_track
  end


  def convert_time(ms)
    #Time.at(1427021993900/1000).utc
    return Time.at(ms/1000).utc
  end

  def check_data
    unless (params.has_key?(:longitude)&& params.has_key?(:latitude)&& params.has_key?(:speed) && params.has_key?(:time))
      render status: :bad_request, :json => {:success => false, :info => "Required parameters not present: longitude, latitude, speed, time", clear: true}
    end
    if (params[:speed].to_f == 0)
      render status: :bad_request, :json => {:success => false, :info => "Speed can't be zero!", clear: true}
    end
  end
end
