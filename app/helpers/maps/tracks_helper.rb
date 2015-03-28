module Maps::TracksHelper
	def correct_param
		if !params.has_key?(:car)
			render status: :bad_request, :json => { :success => false, :info => "Car is not defined!"} 
		elsif !Car.exists?(id: params[:car])
			render status: :bad_request, :json => { :success => false, :info => "Car is not finded!"}
		end
	end
end
