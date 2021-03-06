module CarsHelper
	def car_image car, type=:medium,arg={}
		arg[:alt]||=car.title;
		arg[:class]||="img-rounded car-small-image";
		if car.image 
            image_tag(car.img.url(type), arg )
        else
            arg[:size]=Image::SIZES[type]
            image_tag("icons/auto-icon.png", arg)
        end
    end

    def delete_car_for car
        link_to car, 
        class: "btn btn-sm btn-danger",
            type:"button", 
            "data-toggle" => "tooltip", 
            "data-original-title"=>t("delete_but"), 
            "data-confirm"=>t("modals.del_car_confirm_html", title: car.title),
        method: :delete do 
            content_tag(:i,"", class:"glyphicon glyphicon-remove")
        end
    end

    def edit_car_for car
                link_to edit_car_path(car), id:"car#{car.id}edit", 
        class: "btn btn-sm btn-warning",
            type:"button", 
            "data-toggle" => "tooltip", 
            "data-original-title"=>t("edit_but"), 
        method: :get do 
                content_tag(:i,"", class:"glyphicon glyphicon-edit")
            end
   end
end
