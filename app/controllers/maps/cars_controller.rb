class Maps::CarsController <  Maps::JsonController
	def index
		render status: 200, :json => { :success => true, cars: current_user.cars , :info => "ok!"}
	end
end
