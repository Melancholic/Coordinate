module SessionsHelper
  def sign_in(user)
    remember_token = User.new_remember_token();
    cookies.permanent[:remember_token] = remember_token;
    user.update_attribute(:remember_token, User.encrypt(remember_token));
    self.current_user=user;
  end

  def current_user=(user)
    @current_user=user;
  end

  def current_user
    remember_token= User.encrypt(cookies[:remember_token]);
    @current_user ||= User.find_by(remember_token: remember_token);
  end

  def current_user?(user)
    user==current_user;
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out()
    current_user.update_attribute(:remember_token, User.encrypt(User.new_remember_token));
    cookies.delete(:remember_token);
    self.current_user=nil;
  end

  def save_target_url()
    session[:return_to] = request.url if request.get?;
  end

  def  redirect_to_target_url(default)
    redirect_to(session[:return_to] || default);
    session.delete(:return_to);
  end
  def signed_in_user
    if(!signed_in?)
      save_target_url();
      redirect_to(signin_url, notice:"Please, sign in!");
    end
  end
  def signing_user
    if(signed_in?)
      redirect_to(user_url(self.current_user));
    end
  end
  def verificated_user
      if(current_user.nil?)
        return
      end
      if(!current_user.verificated?)
        redirect_to(verification_user_url(current_user), notice:"Please, verificated your e-mail!");
      end
  end
end
