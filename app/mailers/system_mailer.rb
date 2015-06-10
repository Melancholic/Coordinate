class SystemMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  include ApplicationHelper
  default from: "coordinate@anagorny.com"

	def contact_us_mail(user_mail, target_user)
	    @user = target_user;
	    @mail= user_mail;
	    @tz=@user.time_zone
	    mail(to: @user.email, subject: @mail.subject)
 	end
end
