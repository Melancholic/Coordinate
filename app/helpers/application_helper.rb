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
  
    def duration_humanize(dur)
        case(dur)
        when 0..1
            return "#{(dur*60.0).round()} sec"
        when  1..60
            return "#{(dur).round()} min"
        when 60..1.0/0
            return "#{(dur*1.0/60).round(2)} h"
        else
            return "dur"
        end
    end
end
