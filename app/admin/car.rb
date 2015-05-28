ActiveAdmin.register Car do
    menu priority: 3
  permit_params do 
    permitted=[:id,:title, :description, :uuid, :user_id, :color, :priority];
    permitted
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Car Details" do
      f.input :user_id, :label => 'User', :as => :select, :collection => User.all.map{|u| ["#{u.login}", u.id]}
      f.input :title
      f.input :description
      f.input :color, as: :select, :collection =>Color.all, label: "Color"

      f.input :priority
    end
    f.actions                                        
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
