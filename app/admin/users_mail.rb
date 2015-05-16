ActiveAdmin.register UsersMail do
menu priority: 3
  permit_params do 
    permitted=[:first_name, :last_name, :email, :subject, :message, :opened, :user_id];
    permitted
  end
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
