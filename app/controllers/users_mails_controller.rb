class UsersMailsController < ApplicationController
	include SimpleCaptcha::ControllerHelpers
	def new
	end

	def create
		@mail = UsersMail.new(users_mails_params());
		@mail.host = request.remote_ip;
		puts @mail.captcha;
		if(@mail.save_with_captcha)
			flash[:success] = "Thank you for your message! We will contact you as soon as possible!";
			respond_to do |format|
				format.html {redirect_to root_path}
				#format.js {render :js => "window.location = '#{root_path}'"}
				format.js {render partial:'reset_modal.js.erb'}
				format.json
			end
		else
			respond_to do |format|
				format.html {render 'new'}
				format.json { render :json => {errors: @mail.errors.full_messages} }
				format.js
			end
		end
	end


	protected
	def users_mails_params
		params.require(:users_mail).permit(:email,:first_name,:last_name,:subject,:message, :user_id, :captcha, :captcha_key);
	end
end


