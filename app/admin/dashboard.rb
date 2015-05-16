ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
  #  div class: "blank_slate_container", id: "dashboard_default_message" do
  #    span class: "blank_slate" do
  #      span I18n.t("active_admin.dashboard_welcome.welcome")
  #      small I18n.t("active_admin.dashboard_welcome.call_to_action")
  #    end
  #  end
    columns do
        column min_width: "500px" do
            panel 'Opened user requests' do
                paginated_collection( UsersMail.per_page_kaminari(params[:umails_page]).per(5), param_name: 'umails_page') do
                    table_for(collection) do  |x|
                        column 'Opened', :opened do|object|
                            object.opened? ?  status_tag( "yes", :ok ) : status_tag( "no" )
                        end
                        column 'Аuthor' do |x|
                            x.first_name+' '+x.last_name unless x.user
                            link_to( x.first_name+' '+x.last_name, admin_user_path(x.user)) if x.user
                        end
                        column  'email:' do |y|
                            mail_to y.email
                        end 
                        column 'Subject', :subject
                        column "Operations" do |x|
                            link_to('Show', admin_users_mail_path(x))+" | "+
                            link_to('Edit status', edit_admin_users_mail_path(x))
                        end
                        #column "Message", :message
                            #other columns...
                        #end
                    end
                end
            end
        end
            column min_width: "500px" do
                panel 'System notifications' do
                    paginated_collection( User.per_page_kaminari(params[:users_page]).per(15), param_name: 'users_page') do
                        table_for(collection) do  |x|
                            "..."
                        end
                    end
                end
            end
            column min_width: "500px" do
                panel 'Database info' do
                    info={}
                    config   = Rails.configuration.database_configuration
                    info[:dbname]=config[Rails.env]["database"]
                    info[:dbsize]=ActiveRecord::Base.connection.execute("SELECT pg_size_pretty(pg_database_size('#{info[:dbname]}'))").first.first.last
                    info[:tables]=ActiveRecord::Base.connection.execute("SELECT count(relname) as tables_count 
                        FROM pg_class WHERE relname not SIMILAR TO '(pg|sql)_%' AND relkind = 'r';").
                        first['tables_count'] || '???'
                    info[:indexes]=ActiveRecord::Base.connection.execute("SELECT count(relname) as tables_count 
                        FROM pg_class WHERE relname not SIMILAR TO '(pg|sql)_%' AND relkind = 'i';").
                        first['tables_count'] || '???'
                    info[:rows]=ActiveRecord::Base.connection.execute("SELECT
                          SUM(pgClass.reltuples) AS rows
                        FROM
                          pg_class pgClass
                        LEFT JOIN
                          pg_namespace pgNamespace ON (pgNamespace.oid = pgClass.relnamespace)
                        WHERE
                          pgNamespace.nspname NOT IN ('pg_catalog', 'information_schema') AND
                          pgClass.relkind='r';").first['rows']

                    table_for (info) do  |x|
                        column 'Database',:dbname
                        column 'Size',:dbsize
                        column 'Tables',:tables
                        column 'Indexes',:indexes
                        column 'Rows',:rows
                    end
                    table_for (info) do  |x|
                        column 'Database',:dbname
                        column 'Size',:dbsize
                        column 'Tables',:tables
                        column 'Indexes',:indexes
                        column 'Rows',:rows
                    end
                end
            end
        end
        columns do
            column min_width: "500px" do
                panel 'Last users' do
                    paginated_collection( User.lasted.per_page_kaminari(params[:users_page]).per(5), param_name: 'users_page') do
                        table_for(collection) do  |x|
                            column 'id', :id
                            column 'avatar' do |y|
                                image_tag(y.avatar, height:"20") if y.profile && y.profile.image
                            end
                            column 'login' do |y|
                                link_to  y.login, admin_user_path(y)
                            end
                            column 'email' do |y|
                                mail_to y.email
                            end
                            column 'created_at', :created_at
                        end
                    end
                end
            end
            column min_width: "500px" do
                panel 'Last cars' do
                    paginated_collection( Car.lasted.per_page_kaminari(params[:cars_page]).per(5), param_name: 'cars_page') do
                        table_for(collection) do  |x|
                            column 'id', :id
                            column 'title' do |y|
                                link_to  y.title, admin_car_path(y)
                            end
                            column 'image' do |y|
                                image_tag(Car.first.image.img.url(:icon), height:"20") if y.image
                            end
                            column 'user' do |y|
                                link_to  y.user.login, admin_user_path(y.user)
                            end
                            column 'created_at', :created_at
                        end
                    end
                end
            end
        end
        "<p>Hello!</p>"
    end # content
end
