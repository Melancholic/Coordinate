module ApplicationHelper
  def app_name
    Rails.application.class.parent_name
  end

  def full_title(page_title)
    if (page_title.empty?)
      app_name
    else
      "#{page_title} | #{app_name}"
    end
  end

  def formated_text(text)
    raw text.split("\n").join("<br>")
  end
  
end
