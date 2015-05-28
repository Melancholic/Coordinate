ActiveAdmin.register User do
  menu priority: 2
  permit_params do 
    permitted=[:id,:login, :email, :admin, :password, :password_confirmation, :ip_address, :avatar];
    permitted.append(profile_attributes:[:name,:second_name,:middle_name,:img,:mobile_phone,:country, :city,:region, image_attributes:[:img]]);
    permitted
  end
  
  show do |x|
    attributes_table do
      row :id
      row :login
      row :email
      row :verificated do|object|
        object.verificated? ?  status_tag( "yes", :ok ) : status_tag( "no" )
      end
      row :created_at
      row :updated_at
      row :admin do|object|
        object.admin? ?  status_tag( "yes", :ok ) : status_tag( "no" )
      end
      row :time_zone
   end
   panel 'Profile details' do
     attributes_table_for x.profile do
        row :id
        row 'Image' do |p|
          image_tag(p.image.img.url(:normal)) unless p.image.nil?
        end
        row :name
        row :second_name
        row :middle_name
        row :mobile_phone
        row :country
        row :region
        row :city
        row :created_at
        row :updated_at
      end
    end
   active_admin_comments
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
