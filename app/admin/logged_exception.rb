ActiveAdmin.register ExceptionLogger::LoggedException, as: "Exception" do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
    actions :index, :show;
    permit_params do
       permitted = [:fixed]
    #   permitted << :other if resource.something?
       permitted
    end

    member_action :lock, method: :put do
        resource.lock!
        redirect_to resource_path, notice: "Locked!"
    end

    show do
        attributes_table do
            row :id
            row :fixed do|object|
               object.fixed? ?  status_tag( "yes", :ok ) : status_tag( "no" )
           end
            row :created_at
            row :updated_at
            row :exception_class
            row :message
            row :controller_name
            row :action_name
            row :request
            row :environment do |x|
                raw x.environment.split("\n").join("<br>")
            end
            row :backtrace do |x|
                raw x.backtrace.split("\n").join("<br>")
            end
        end
        active_admin_comments
    end
    

    index do 
        selectable_column
            column :id
            column :fixed do|object|
               object.fixed? ?  status_tag( "yes", :ok ) : status_tag( "no" )
           end
            column :created_at
            column :updated_at
            column :exception_class
            column :message
            column :controller_name
            column :action_name
            column :request
            actions
          
    end

    member_action :switch_status, method: :put do
        resource.fixed=!resource.fixed;
        if(resource.save)
            redirect_to resource_path, notice: "Exception status set is #{(resource.fixed?) ? 'fixed' : 'non fixed' }"
        else
          redirect_to resource_path, notice: "Errors: #{resource.errors.map{ |x,y| "#{x.to_s} #{ y}"}.join(";  ")}."      
        end
    end
    
    action_item :switch_status, only: :show do
        link_to 'Switch status', switch_status_admin_exception_path(exception), method: :put
    end
end
