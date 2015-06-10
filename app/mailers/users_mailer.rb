class UsersMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  include ApplicationHelper
  default from: "coordinate@anagorny.com"

  def verification(user)
    @user=user;
    mail to: user.email, subject:"Verification your e-mail"
  end

  def verificated(user)
  @user=user
    mail to: user.email, subject:"Welcome to #{app_name} Project!"
  end

  def recived_email_for_passrst(user)
    @user=user;
    @host=user.reset_password.host
    @time=user.reset_password.updated_at.strftime("%Y-%m-%d %H:%M:%S")
    mail to: user.email, subject:"Reset your password in #{app_name}"
  end

  def send_new_pass_notification(user)
    @user=user;
    @host=user.reset_password.host
    @time=user.reset_password.updated_at.strftime("%Y-%m-%d %H:%M:%S")
    mail to: user.email, subject:"Password reset successfully!"
  end

end
