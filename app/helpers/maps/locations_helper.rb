module Maps::LocationsHelper
	def correct_param
		if !params.has_key?(:tracks)
			render status: :bad_request, :json => { :success => false, :info => "Tracks is not defined!"} 
		end
	end
end
