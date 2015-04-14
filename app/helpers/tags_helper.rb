module TagsHelper
  def color_to(arg)
  	color=(arg.instance_of? Car)?arg.color : arg ;
    raw "<span class='btn' style='background-color: ##{color};'></span>"
  end
end