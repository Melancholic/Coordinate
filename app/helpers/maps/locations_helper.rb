module Maps::LocationsHelper
	def correct_param
		if !params.has_key?(:tracks)
			render status: :bad_request, :json => { :success => false, :info => "Tracks is not defined!"} 
		end
	end
	def correct_param_for_show
		if !params.has_key?(:id)
			render status: :bad_request, :json => { :success => false, :info => "Location ID is not defined!"} 
		elsif !(x=TrackLocation.find_by_id(params[:id])) && (x.track.car.user==current_user)
			render status: :bad_request, :json => { :success => false, :info => "Location not founded!"} 
		end
	end
end
