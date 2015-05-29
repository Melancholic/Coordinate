module Maps::TracksHelper
	def correct_param
		if !params.has_key?(:car) 
			render status: :bad_request, :json => { :success => false, :info => "Car is not defined!"} 
		elsif !Car.by_user(current_user).exists?(id: params[:car])
			render status: :bad_request, :json => { :success => false, :info => "Car is not finded!"}
        end
	end

    def correct_param_for_info
        if !params.has_key?(:track_id) 
            render status: :bad_request, :json => { :success => false, :info => "Track ID is not defined!"} 
        elsif !Track.by_user(current_user).exists?(id: params[:track_id])
            render status: :bad_request, :json => { :success => false, :info => "Track is not finded!"}
        end
    end


    def correct_param_for_info_all
        puts params[:track_ids]
        if !params.has_key?(:track_ids) 
            render status: :bad_request, :json => { :success => false, :info => "Track ID is not defined!"} 
        end
    end
end
