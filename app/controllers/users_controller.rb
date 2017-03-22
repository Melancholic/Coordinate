class UsersController < HTTPApplicationController
  before_action :user_exist
  #for not signed users redirect to root
  before_action :signed_in_user, only:[:show,:index,:edit,:update, :destroy,  :verification, :sent_verification_mail, :charts_controller] # in app/helpers/session_helper.rb
  before_action :verificated_user, only:[:index, :destroy,:show, :charts_controller]
  #For verificated user - redirect to root
  before_action :verificated_user_is_done, only: [:verification, :sent_verification_mail]
  #for signied users
  before_action :correct_user, only:[:edit,:update,:verification, :show, :charts_controller]
  #for admins
  before_action :admin_user, only: :destroy
  #for signed for NEW and CREATE
  before_action :signed_user_to_new, only:[:new, :create,:reset_password]
  include SimpleCaptcha::ControllerHelpers
  #before_action :check_captcha, only:[:create]
  def new
    @user||=User.new();
  end

  def show()
    @user = current_user; 
    @cars = @user.cars.paginate(page: params[:page]);
    if(@user.all_tracks.count>0)
      @days=TimeDifference.between(@user.all_tracks.last.start_time, @user.all_tracks.first.start_time).in_days.round+1
      @total_tracks=@user.all_tracks.count
      @total_distance=Track.total_distance_for_user(current_user).round(3)
      @average_distance=(@total_distance/@total_tracks).round(3)
      @cars_with_tracs=current_user.cars.to_a.delete_if{|x| x.tracks.empty?}
      @average_distance_per_car=(@total_distance/@cars_with_tracs.count).round(3)
      @average_distance_per_day=(@total_distance/@days).round(3)
      @favorite_car=@user.cars.max_by{|x| x.tracks.count}
      @average_tracks_per_day=(@total_tracks/@days).round(1)
      @average_tracks_per_car=(@total_tracks/@cars_with_tracs.count).round(1)
    end
    respond_to do |format|
      format.html 
      format.json
      format.js {render 'paginate.js'}
    end

  end


  def create
    @user = User.new(user_params());
    @user.build_profile;
    if(@user.save_with_captcha)
      flash[:success] = t("modals.welcome_msg", user:@user.login);;
      sign_in @user;
      UsersMailer.verification(@user).deliver_now;
      respond_to do|format|
        format.html{redirect_to(@user)};
        #redirect to root page
        format.js{render js: "window.location.href = '#{root_path}';"}
      end
    else
      respond_to do |format|
        format.js {render 'ajax_new.js'}
        format.html {redirect_to :back}
        format.json { render :json => {errors: @user.errors.full_messages} }
      end
    end
  end

  def edit
    #Has been added in app/helpers/sessions_helper.rb:current_user?(user)
   #@user= User.find(params[:id]);
  end

  
  def update
   #Has been added in app/helpers/sessions_helper.rb:current_user?(user)
   @user= User.find(params[:id]);
   if  (@user.update_attributes(user_params()))
      if(@user.locale!=session[:locale])
        session.delete(:locale)
      end
      flash[:success] =  t('modals.usr_updating')
      redirect_to(@user);
    else
        render 'edit';
    end
  end

  def destroy
    ulogin=User.find(params[:id]).login;
    if(User.find(params[:id]).destroy)
      flash[:success]= t('modals.usr_deleted', login: ulogin);
    else
      flash[:error]=t('modals.usr_not_deleted', login: ulogin);
    end
    redirect_to(users_url);
 end

#verification meil sent  function (step 1 in create)
  def sent_verification_mail()
    @user= User.find(params[:id]);
    UsersMailer.verification(@user).deliver_now;
    flash[:success]=t('modals.send_verif_instruct', email: @user.email);
    redirect_to(verification_user_url(@user));
  end

#verification step2
 def verification
  @user= User.find(params[:id]);
  @verification_key=@user.verification_key;
  if(params[:key])
    if(params[:key]==@user.verification_key)
      @user.verification_user.update(verification_key:"",verificated:true);
      UsersMailer.verificated(@user).deliver_now;
      flash[:success]=t('modals.user_verificated', user: @user.login);
      redirect_to(user_path(@user));
    else
      flash[:error]=t('modals.user_not_verificated', user: @user.login);
      render('verification');
    end
  end
 end
  
  def reset_password
    @title="Reset Password";
    if (!params[:key] || !ResetPassword.get_user(params[:key]))
      @request_email=true;
    else
      @request_email=false;
      user=ResetPassword.get_user(params[:key])
      if(TimeDifference.between(Time.now, user.reset_password.updated_at).in_minutes <=TIME_LIM_PASSRST_KEY)
        @user=user;
        #@key=params[:key];
      else
        user.reset_password.destroy;
        flash[:error]=t('modals.lifetime_ended');
        redirect_to(reset_password_users_url);
      end
    end
  end

  def recive_email_for_reset_pass
    user=User.find_by(email: params[:email]);
    host=request.remote_ip;
    if(user)
      #Make key for reset
      user.make_reset_password(host:host);
      #user.reset_password= ResetPassword.create(user_id: user.id, host:host);
      UsersMailer.recived_email_for_passrst(user).deliver_now;
      flash[:success]=t('modals.reset_pass_send', email: user.email);
      redirect_to(root_url);
    else
      flash[:error]=t('modals.reset_pass_email_not_founded', email: params[:email]);
      redirect_to(reset_password_users_url);
    end
  end

  def resetpass_recive_pass
   @user = User.find(params[:format]);
   if  (@user.update_attributes(user_params()))
      flash[:success] =  t('modals.usr_updating');
      redirect_to(root_url);
      UsersMailer.send_new_pass_notification(@user).deliver_now;
      @user.reset_password.destroy;
    else
      @title="Reset Password";
      render 'reset_password';
    end
  end

  def charts_controller
    case(params[:request])
      when "speed_avg"
        result={success:true,result:TrackLocation.where(track: current_user.all_tracks).average('speed').to_f.round};
      when "speed_max"
        result={success:true,result:TrackLocation.where(track: current_user.all_tracks).maximum('speed').to_f.round};
      when "percent_tracks_for_cars"
        @cars_with_tracs=current_user.cars.to_a.delete_if{|x| x.tracks.empty?}
        colors=[];
        data=@cars_with_tracs.map do |x| 
          colors.append("##{x.color}");[x.title, x.tracks.count*1.0/current_user.all_tracks.count]
        end
        result={success:true, result:{data: data, colors: colors}};
      when "percent_distance_for_cars"
        @cars_with_tracs=current_user.cars.with_tracks
        colors=[];
        data=@cars_with_tracs.map do |x| 
          distance = TrackLocation.unscoped.where(track: x.tracks).group('track_id').maximum(:distance).values.compact.sum
          colors.append("##{x.color}");
          [x.title, distance]
        end
        result={success:true, result:{data: data, colors: colors}};
      when "length_tracks_of_time"
        data=[];
        data.push(current_user.group_tracks_by_day(:all))
        current_user.cars.with_tracks.limit(10).each{|x|  data.push(current_user.group_tracks_by_day(x)) }
        result={success:true, result: data.compact};
      else 
        result= {:status => :bad_request,
          :json => { :success => false,
          :info => "Bad json!" 
        }};
    end

    respond_to do |format|
      format.json { render json: result }
    end


  end

protected
  def user_params
    params.require(:user).permit(:login,:email,:password, :password_confirmation, 
        :time_zone, :captcha, :captcha_key, :locale,
      profile_attributes:[:id,:name,:second_name,:middle_name,:img,
        :mobile_phone,:country, :city,:region, 
        image_attributes:[:id, :img, :_destroy]]);
  end
private


  #before-filter
  def user_exist
    if(params[:id])
      unless User.find_by_id(params[:id])
        flash[:error]=t('modals.uncorrect_params');
        logger.error("User with params[:id]=#{params[:id]} not founded!")
        redirect_to(root_url);
      end
    else
      true
    end
  end

  def correct_user
    @user=User.find_by_id(params[:id]);
    if (!current_user?(@user))
      redirect_to(root_url);
    end
  end

  def verificated_user_is_done
    if ( current_user.verificated?)
      redirect_to(root_url);
    end
  end

  def admin_user
    if (current_user==User.find(params[:id]))
       flash[:error]=t('modals.user_not_deleted_self');
       redirect_to(users_url);

    else
      redirect_to(root_url) unless current_user.admin?;
    end
  end
  
  def signed_user_to_new
    if(!current_user?(@user))
        redirect_to(root_url);
    end
  end

end
