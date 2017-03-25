class CarsController < HTTPApplicationController
  before_action :signed_in_user # in app/helpers/session_helper.rb
  before_action :verificated_user
  before_action :car_exist
  before_action :correct_car


  def show
    @car= Car.find(params[:id]);
    
  end

  def index
  @cars = current_user.cars.paginate(page: params[:page]);
  respond_to do |format|
    format.html # index.html.erb
    format.json { render json: @cars }
    format.js
  end
end

def new
  @car=current_user.cars.build;
end

	def create
   @car = current_user.cars.build(car_params());
    if(@car.save)
      flash[:success] = t('modals.car_saved');
      redirect_to(cars_path);
    else
      respond_to do |format|
        format.html {render 'new'}
        format.json { render :json => {errors: @user.errors.full_messages} }
      end
    end
	end
  
  def edit
    @car=Car.find(params[:id]);
  end
  
  def update
    @car=Car.find(params[:id]);
   if  (@car.update_attributes(car_params()))
      flash[:success] = t('modals.car_updating', car:@car.title)
      redirect_to(cars_path);
    else
        render 'edit';
    end
  end

  def index
  @cars = current_user.cars.paginate(page: params[:page]);
  respond_to do |format|
    format.html 
    format.json { render json: @cars }
    format.js {render 'paginate.js'}
  end
end

def destroy
  car= Car.find(params[:id]);
  title=car.title;
  if(car.destroy)
    flash[:success] = t('modals.car_deleting', car:title);
  else
    flash[:error] =  t('modals.car_not_deleting', car:title);
  end
  redirect_to (cars_path);
end

def info
  @car=Car.find(car_params[:id]);
  car_info=@car.info();
    respond_to do |format|
    format.json { render json: car_info }
  end

end

protected
  def car_params
    params.require(:car).permit(:id, :title, :description, :user_id, :color, :priority, image_attributes:[:id, :img, :_destroy]);
  end

  def car_exist
    if(params.has_key?(:id))
      unless Car.find_by_id(params[:id])
        flash[:error]=t('modals.uncorrect_params')
        logger.error("Car with params[:id]=#{params[:id]} not founded!")
        redirect_to(user_path(current_user)); 
      end
    else
      true
    end
  end

  def correct_car
    if params.has_key?(:id)
      car=Car.find_by_id(params[:id]);
      unless (current_user==car.user)
        flash[:error]=t('modals.uncorrect_params');
        logger.error("Unauthorized  access to a car with id=#{car.id} by user id=#{current_user.id}!")
        redirect_to(user_path(current_user)); 
      end
    end
  end

end
