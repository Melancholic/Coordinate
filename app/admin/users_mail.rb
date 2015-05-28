ActiveAdmin.register UsersMail, as: "Ticket" do
    actions :index, :show;

    member_action :switch_status, method: :put do
        resource.opened=!resource.opened;
        if(resource.save)
            redirect_to resource_path, notice: "Ticket status set is #{(resource.opened?) ? 'opened' : 'closed' }"
        else
          redirect_to resource_path, notice: "Errors: #{resource.errors.map{ |x,y| "#{x.to_s} #{ y}"}.join(";  ")}."      
        end
    end

    show do
        attributes_table do
            row :id
            row :first_name
            row :last_name
            row :user_id do |x|
                link_to x.user.login, admin_user_path(x.user) unless x.user.nil?
            end
            row :email do |x|
                mail_to x.email
            end
            row :subject
            row :message do |x|
                formated_text(x.message)
            end
            row :opened do|object|
               object.opened? ?  status_tag( "yes", :ok ) : status_tag( "no" )
            end
            row :host
            row :created_at
            row :updated_at
        end
        active_admin_comments
    end

        index do 
        selectable_column
            column :id do |object|
                link_to object.id, admin_ticket_path(object)
            end
            column :opened do|object|
                object.opened? ?  status_tag( "yes", :ok ) : status_tag( "no" )
            end
            column :user do |x|
                link_to x.user.login, admin_user_path(x.user) unless x.user.nil?
            end
            column :email do |x|
                mail_to x.email
            end
            column :subject do |x|
                x.subject.truncate(35)
            end
            column :host
            column :created_at
            column :updated_at
            actions
          
    end

    action_item :switch_status, only: :show do
        link_to 'Switch status', switch_status_admin_ticket_path(ticket), method: :put
    end
end
