class UsersController < ApplicationController
  #for not signed users redirect to root
  before_action :signed_in_user, only:[:index,:edit,:update, :destroy,  :verification, :sent_verification_mail] # in app/helpers/session_helper.rb
  before_action :verificated_user, only:[:index, :destroy,:show, :following, :followers]
  #For verificated user - redirect to root
  before_action :verificated_user_is_done, only: [:verification, :sent_verification_mail]
  #for signied users
  before_action :correct_user, only:[:edit,:update,:verification]
  #for admins
  before_action :admin_user, only: :destroy
  #for signed for NEW and CREATE
  before_action :signed_user_to_new, only:[:new, :create,:reset_password]
 
  def new
    @user=User.new();
  end

  def show()
    @user = User.find(params[:id]); 
    @microposts=@user.microposts.paginate(page: params[:page]);
    @micropost=current_user.microposts.build if(signed_in?);
    @mypath = user_path(@user);
  end

  def index()
    #@users =  User.all.sort_by { |s| s.name };
    @users=User.paginate(page: params[:page]);
  end

  def create
    @user = User.new(user_params());
    if(@user.save)
      flash[:success] = "Welcome to Tweets!";
      sign_in @user;
      redirect_to(@user);
      TweetsMailer.verification(@user).deliver_now;
    else
      render 'new';
    end
  end

  def edit
    #Has been added in app/helpers/sessions_helper.rb:current_user?(user)
    #@user= User.find(params[:id]);
  end
  
  def update
   #Has been added in app/helpers/sessions_helper.rb:current_user?(user)
   #@user= User.find(params[:id]);
   if  (@user.update_attributes(user_params()))
      flash[:succes] = "Updating your profile is success"
      redirect_to(@user);
    else
        render 'edit';
    end
  end

  def destroy
    uname=User.find(params[:id]).name;
    if(User.find(params[:id]).destroy)
      flash[:success]="User #{uname} has been deleted!";
    else
      flash[:error]="User #{uname} has not been deleted!";
    end
    redirect_to(users_url);
 end

#verification meil sent  function (step 1 in create)
  def sent_verification_mail()
    @user= User.find(params[:id]);
    TweetsMailer.verification(@user).deliver_now;
    flash[:success]="Mail to #{@user.email} has been sended!";
    redirect_to(verification_user_url(@user));
  end

#verification step2
 def verification
  @user= User.find(params[:id]);
  @verification_key=@user.verification_key;
  if(params[:key])
    if(params[:key]==@user.verification_key)
      @user.verification_user.update(verification_key:"",verificated:true);
      TweetsMailer.verificated(@user).deliver_now;
      flash[:success]="User #{@user.name} has been verificated!";
      redirect_to(user_path(@user));
    else
      flash[:error]="User #{@user.name} has not been verificated!";
      render('verification');
    end
  end
 end
  
  def reset_password
    @title="Reset Password";
    if (!params[:key] || !ResetPassword.getUser(params[:key]))
      @request_email=true;
    else
      @request_email=false;
      user=ResetPassword.getUser(params[:key])
      if(TimeDifference.between(Time.now, user.reset_password.updated_at).in_minutes <=TYME_LIM_PASSRST_KEY)
        @user=user;
        #@key=params[:key];
      else
        user.reset_password.destroy;
        flash[:error]="The lifetime of this reference completion. Please try the request again.";
        redirect_to(reset_password_users_url);
      end
    end
  end

  def recive_email_for_reset_pass
    user=User.find_by(email: params[:email]);
    host=request.remote_ip;
    if(user)
      flash[:success]="Mail with instructions has been sended to e-mail:  #{user.email}!";
      #Make key for reset
      user.make_reset_password(host:host);
      #user.reset_password= ResetPassword.create(user_id: user.id, host:host);
      TweetsMailer.recived_email_for_passrst(user).deliver_now;
      redirect_to(root_url);
    else
      flash[:error]="User with e-mail: #{params[:email]} not found!";
      redirect_to(reset_password_users_url);
    end
  end

  def resetpass_recive_pass
   @user = User.find(params[:format]);
   if  (@user.update_attributes(user_params()))
      flash[:succes] = "Updating your profile is success"
      redirect_to(root_url);
      TweetsMailer.send_new_pass_notification(@user).deliver_now;
      @user.reset_password.destroy;
    else
      @title="Reset Password";
      render 'reset_password';
    end
  end

private

  def user_params
    params.require(:user).permit(:name,:email,:password, :password_confirmation);
  end

  #before-filter
  
  def correct_user
    @user=User.find(params[:id]);
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
       flash[:error]="You has not been deleted!";
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
