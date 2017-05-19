class SessionsController < HTTPApplicationController
  before_action :signing_user, only:[:new] # in app/helpers/session_helper.rb
  before_action :signed_in_user, only:[:destroy]
  include SimpleCaptcha::ControllerHelpers
  before_action :check_captcha, only:[:create]
  skip_before_action :user_is_agreed, only: [:set_custom_locale, :destroy]

  def new
  end

  def create
    user= User.find_by(email: params[:session][:email].downcase)
    if(user && user.authenticate(params[:session][:password]))
        sign_in(user)
        #flash[:success]=t("modals.welcome_msg", user:user.login)
        redirect_to(root_url)
    else
      flash[:error]=t("modals.uncorrect_login_data")
      redirect_to(:back)
    end
  end

  def set_custom_locale
    puts 
      if (params.has_key?(:locale) && LANGUAGES.map(&:second).include?(params[:locale]))
        session[:locale]=params[:locale]
      else
        flash[:error]=t('flash.error.uncorrect_locale')
      end
      respond_to do |f|
        f.js { render 'set_custom_locale.js'}
      end
  end

  def destroy
    sign_out
    redirect_to(root_url)
  end

  def check_captcha
    unless simple_captcha_valid?
       flash[:error]= I18n.t('simple_captcha.message.user')
       redirect_to(:back)
    end
  end

end
