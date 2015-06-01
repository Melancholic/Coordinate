crumb :root do
  link t("breadcrumbs.home"), root_path
end
 crumb :profile do |user|
   link t("breadcrumbs.profile"), user_path(user)
 end
 crumb :settings do |user|
   link t("breadcrumbs.settings"), edit_user_path(user)
   parent :profile, user
 end
 crumb :cars do |user|
   link t("breadcrumbs.cars"), cars_path
   parent :settings, user
 end

 crumb :new_car do |user|
   link t("breadcrumbs.new_cars"), new_car_path
   parent :cars, user
 end
  crumb :edit_car do |user|
   link t("breadcrumbs.edit_cars"), new_car_path
   parent :cars, user
 end
# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).