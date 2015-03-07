ActiveAdmin.register User do
  permit_params :login, :email,:admin, :password, :password_confirmation
  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "User Details" do
      f.input :login
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.inputs "User Perference" do
      f.input :admin, type: :boolean
    end
    f.actions                                        
  end

  action_item do
  #  link_to("Reset Password",reset_password_admin_user_path(user))
  end
#	member_action :reset_password do
#	  user = User.find(params[:id])
#	  user.send_reset_password_instructions
#	  redirect_to(admin_user_path(admin_user),
#		notice: "Password reset email sent to #{admin_user.email}")
#	end
end
