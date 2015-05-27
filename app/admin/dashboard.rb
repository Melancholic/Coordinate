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
                paginated_collection( UsersMail.per_page_kaminari(params[:umails_page]).per(5), param_name: 'umails_page', download_links:false) do
                    table_for(collection) do  |x|
                        column 'Opened', :opened do|object|
                            object.opened? ?  status_tag( "yes", :ok ) : status_tag( "no" )
                        end
                        column 'Аuthor' do |x|
                            if x.user
                                link_to( x.first_name+' '+x.last_name, admin_user_path(x.user)) 
                            else
                                x.first_name+' '+x.last_name
                            end
                        end

                        column 'Subject' do |x|
                            x.subject.truncate(30);
                        end
                        column 'Created at' do |x|
                            x.created_at.strftime("%d.%m.%y %H:%m")
                        end
                        column "Operations" do |x|
                            link_to('Show', admin_users_mail_path(x))+" | "+
                            link_to('Close', edit_admin_users_mail_path(x))
                        end
                        #column "Message", :message
                            #other columns...
                        #end
                    end
                end
            end
                 panel 'Statistics for the month users requests' do
                    div do 
                        render 'stat_of_urequests', opened:UsersMail.opened.where('created_at >= ?',Time.now.utc.beginning_of_year).count, 
                                                    closed:UsersMail.closed.where('created_at >= ?',Time.now.utc.beginning_of_year).count;
                    end 
                end
        end
            column min_width: "500px" do
                panel 'System notifications' do
                    paginated_collection( ExceptionLogger::LoggedException.sorted.where(fixed: false).per_page_kaminari(params[:exception_page]).per(5), param_name: 'exception_page', download_links:false) do
                        table_for(collection) do  |x|
                            column 'Fixed', :opened do|object|
                                object.fixed? ?  status_tag( "yes", :ok ) : status_tag( "no" )
                            end
                            column 'Class' do |x|
                                link_to(x.exception_class, admin_exception_path(x))
                            end
                            #column 'Controller', :controller_name
                            column 'Time' do |x|
                                x.created_at.strftime("%d.%m.%y %H:%m")
                            end
                            column "Operations" do |x|
                                link_to('Show', admin_exception_path(x))+" | "+
                                link_to('Close', switch_status_admin_exception_path(x), method: :put)
                            end
                        end
                    end
                end
                panel 'Statistics for the month of notifications' do
                     div do 
                        opened=(ExceptionLogger::LoggedException.unscoped.where("created_at > ?", Time.now.utc.beginning_of_year).where('created_at <> updated_at').where(fixed:false).group_by_month(:created_at).count).map{|k,v| {k.month=>v}}.reduce Hash.new, :merge
                        closed=(ExceptionLogger::LoggedException.unscoped.where("created_at > ?", Time.now.utc.beginning_of_year).where(fixed:true).group_by_month(:created_at).count).map{|k,v| {k.month=>v}}.reduce Hash.new, :merge
                        newed=(ExceptionLogger::LoggedException.unscoped.where("created_at > ?", Time.now.utc.beginning_of_year).where('created_at = updated_at').where(fixed:false).group_by_month(:created_at).count).map{|k,v| {k.month=>v}}.reduce Hash.new, :merge
                        all=(ExceptionLogger::LoggedException.unscoped.where("created_at > ?", Time.now.utc.beginning_of_year).group_by_month(:created_at).count).map{|k,v| {k.month=>v}}.reduce Hash.new, :merge
                        (1 .. Time.now.month).each do |x| 
                            opened[x]=0 unless opened.include? x     
                            closed[x]=0 unless closed.include? x  
                            newed[x]=0 unless newed.include? x 
                            all[x]=0 unless all.include? x 
                        end
                        opened=opened.sort_by{|k| k.first}.map{|k| {k.first=>k.second} }.reduce( Hash.new, :merge)
                        closed=closed.sort_by{|k| k.first}.map{|k| {k.first=>k.second} }.reduce( Hash.new, :merge)
                        newed=newed.sort_by{|k| k.first}.map{|k| {k.first=>k.second} }.reduce( Hash.new, :merge)
                        all=all.sort_by{|k| k.first}.map{|k| {k.first=>k.second} }.reduce( Hash.new, :merge)
                        keys=all.keys.map{|x|Date::MONTHNAMES[x] }
                        render 'stat_of_notifications', data:[keys,opened.values,closed.values,newed.values,all.values]
                     end  
                end
            end
            column min_width: "500px" do
                panel 'Database info' do
                    dbinfo={}
                    config = Rails.configuration.database_configuration
                    dbinfo[:dbname]=config[Rails.env]["database"]
                    dbinfo[:dbsize]=ActiveRecord::Base.connection.execute("SELECT pg_size_pretty(pg_database_size('#{dbinfo[:dbname]}'))").first.first.last
                    dbinfo[:tables]=ActiveRecord::Base.connection.execute("SELECT count(relname) as tables_count 
                        FROM pg_class WHERE relname not SIMILAR TO '(pg|sql)_%' AND relkind = 'r';").
                        first['tables_count'] || '???'
                    dbinfo[:indexes]=ActiveRecord::Base.connection.execute("SELECT count(relname) as tables_count 
                        FROM pg_class WHERE relname not SIMILAR TO '(pg|sql)_%' AND relkind = 'i';").
                        first['tables_count'] || '???'
                    dbinfo[:rows]=ActiveRecord::Base.connection.execute("SELECT
                          SUM(pgClass.reltuples) AS rows
                        FROM
                          pg_class pgClass
                        LEFT JOIN
                          pg_namespace pgNamespace ON (pgNamespace.oid = pgClass.relnamespace)
                        WHERE
                          pgNamespace.nspname NOT IN ('pg_catalog', 'information_schema') AND
                          pgClass.relkind='r';").first['rows']

                    table_for (dbinfo) do  |x|
                        column 'Database',:dbname
                        column 'Size',:dbsize
                        column 'Tables',:tables
                        column 'Indexes',:indexes
                        column 'Rows',:rows
                    end
                    tbinfo= ActiveRecord::Base.connection.execute("SELECT
                          pgClass.reltuples AS rows, pgClass.relname AS table, (pgClass.relpages * 8) / 1024 AS size_mb
                        FROM
                          pg_class pgClass
                        LEFT JOIN
                          pg_namespace pgNamespace ON (pgNamespace.oid = pgClass.relnamespace)
                        WHERE
                          pgNamespace.nspname NOT IN ('pg_catalog', 'information_schema') AND
                          pgClass.relkind='r';").to_a.each(&:symbolize_keys!)
                    table_for (tbinfo) do  |x|
                        column 'Table',:table
                        column 'Rows',:rows
                        column 'Size (MB)', :size_mb
                    end
                end
                panel "Database operations" do

                end
            end
        end
        columns do
            column min_width: "500px" do
                panel 'Last users' do
                    paginated_collection( User.lasted.per_page_kaminari(params[:users_page]).per(5), param_name: 'users_page',  download_links:false) do
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
                            column 'verificated' do |y|
                                y.verificated? ?  status_tag( "yes", :ok ) : status_tag( "no" )
                            end
                            column 'Created at' do |x|
                                x.created_at.strftime("%d.%m.%y %H:%m")
                            end
                        end
                    end
                end
                panel "Statistics of new users per year"do
                     div do 
                        with_cars_array=(User.unscoped.with_cars.group_by_month('users.created_at').count).map{|k,v| {k.month=>v}}.reduce Hash.new, :merge
                        all_array=(User.unscoped.group_by_month('users.created_at').count).map{|k,v| {k.month=>v}}.reduce Hash.new, :merge
                        (1 .. Time.now.month).each do |x| 
                            with_cars_array[x]=0 unless with_cars_array.include? x     
                            all_array[x]=0 unless all_array.include? x
                        end
                        all_array=all_array.sort_by{|k| k.first}.map{|k| {k.first=>k.second} }.reduce( Hash.new, :merge)
                        with_cars_array=with_cars_array.sort_by{|k| k.first}.map{|k| {k.first=>k.second} }.reduce( Hash.new, :merge)
                        keys=all_array.keys.map{|x|Date::MONTHNAMES[x] }
                        render 'stat_of_users', data:[keys,with_cars_array.values,all_array.values]
                     end  
                end
            end
            column min_width: "500px" do
                panel 'Last cars' do
                    paginated_collection( Car.lasted.per_page_kaminari(params[:cars_page]).per(5), param_name: 'cars_page', download_links:false) do
                        table_for(collection) do  |x|
                            column 'id', :id
                            column 'title' do |y|
                                link_to  y.title, admin_car_path(y)
                            end
                            column 'image' do |y|
                                image_tag(y.image.img.url(:icon), height:"20", class:"img img-rounded") if y.image
                            end
                            column 'user' do |y|
                                link_to  y.user.login, admin_user_path(y.user)
                            end
                            column 'Created at' do |x|
                                x.created_at.strftime("%d.%m.%y %H:%m")
                            end
                        end
                    end
                end
                panel "Statistics of new cars per year"do
                     div do 
                        with_tracks_array=(Car.unscoped.with_tracks.group_by_month('cars.created_at').count).map{|k,v| {k.month=>v}}.reduce Hash.new, :merge
                        all_array=(Car.unscoped.group_by_month('cars.created_at').count).map{|k,v| {k.month=>v}}.reduce Hash.new, :merge
                        (1 .. Time.now.month).each do |x| 
                            with_tracks_array[x]=0 unless with_tracks_array.include? x     
                            all_array[x]=0 unless all_array.include? x
                        end
                        all_array=all_array.sort_by{|k| k.first}.map{|k| {k.first=>k.second} }.reduce( Hash.new, :merge)
                        with_tracks_array=with_tracks_array.sort_by{|k| k.first}.map{|k| {k.first=>k.second} }.reduce( Hash.new, :merge)
                        keys=all_array.keys.map{|x|Date::MONTHNAMES[x] }
                        render 'stat_of_cars', data:[keys,with_tracks_array.values,all_array.values]
                     end  
                end
            end
        end
    end # content
end
