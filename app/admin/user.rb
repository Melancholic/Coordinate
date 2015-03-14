ActiveAdmin.register User do
  permit_params do 
    permitted=[:id,:login, :email, :admin, :password, :password_confirmation, :ip_address, :avatar];
    permitted.append(profile_attributes:[:name,:second_name,:middle_name,:img,:mobile_phone,:country, :city,:region, image_attributes:[:img]]);
    permitted
  end

   index do 
    selectable_column
    column "ID", :id
    column 'Image' do |p|
       image_tag(p.avatar, height:"20") if p.profile && p.profile.image
    end
    column :login
    column :email
    column :name
    column :second_name
    column :middle_name
    column :admin do|object|
       object.admin? ?  status_tag( "yes", :ok ) : status_tag( "no" )
   end
    column 'Mobile phone' do |x| x.profile.mobile_phone if x.profile end
    column 'IP', :ip_address
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "User Details" do
      f.input :login
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
     f.inputs "profile", for:  [:profile, f.object.profile || f.object.build_profile] do |pf|
      pf.input :name
      pf.input :second_name
      pf.input :middle_name
      pf.input :mobile_phone, :as => :phone
      pf.input :country,  selected: "RU"
      pf.input :city
      pf.input :region
      #pf.inputs "Avatar", for:  [:image, pf.object.image || pf.object.build_image] do |i|
      #  i.input :img
      #end
    end
    unless controller.action_name == 'new'
      f.inputs "Avatar" do
        f.input :avatar, as: :file
      end
    end
    f.inputs "User Perference" do
      f.input :admin, type: :boolean
    end
    f.actions                                        
  end
  # member_action :reset_password do
#   user = User.find(params[:id])
#   user.send_reset_password_instructions
#   redirect_to(admin_user_path(admin_user),
#   notice: "Password reset email sent to #{admin_user.email}")
# end
end
