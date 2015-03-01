class SessionsController < ApplicationController
  before_action :signing_user, only:[:new] # in app/helpers/session_helper.rb
  before_action :signed_in_user, only:[:destroy]
  def new
  end

  def create
    user= User.find_by(email: params[:session][:email].downcase);
    if(user && user.authenticate(params[:session][:password]))
        sign_in(user)
        flash[:succes]="#{user.login}, welcome!";
        redirect_to(root_url);
    else
        flash[:error]='Uncorrect email or password!'
        redirect_to(:back);
    end
  end

  def destroy
      sign_out;
      redirect_to(root_url);
  end
end
