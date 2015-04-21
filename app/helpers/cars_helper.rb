module CarsHelper
	def car_image car, arg={size:"100x100"}
		arg[:alt]||=car.title;
		arg[:class]||="img-rounded car-small-image";
		if car.image 
            content_tag(:div, image_tag(car.img.url, arg ), class:"col-md-3 col-lg-3 hidden-xs hidden-sm")+
            content_tag(:div, image_tag(car.img.url, arg), class:"col-xs-2 col-sm-2 hidden-md hidden-lg")
        else
            content_tag(:div, image_tag("icons/auto-icon.png", arg), class:"col-md-3 col-lg-3 hidden-xs hidden-sm")+
            content_tag(:div, image_tag("icons/auto-icon.png", arg), class:"col-xs-2 col-sm-2 hidden-md hidden-lg")
        end
    end

    def delete_car_for car
        link_to car, id:"car#{car.id}delete", 
        class: "btn btn-sm btn-danger",
            type:"button", 
            "data-toggle" => "tooltip", 
            "data-original-title"=>"Delete car", 
            "data-confirm"=>"<h4>Are you sure you want to delete this car: <b>#{car.title}</b> ?<br>"+
            "<p class='text-danger'>Warning: All data on it will be deleted permanently!</p></h4>",
        method: :delete do 
            content_tag(:i,"", class:"glyphicon glyphicon-remove")
        end
    end

    def edit_car_for car
                link_to edit_car_path(car), id:"car#{car.id}edit", 
        class: "btn btn-sm btn-warning",
            type:"button", 
            "data-toggle" => "tooltip", 
            "data-original-title"=>"Edit car", 
        method: :get do 
                content_tag(:i,"", class:"glyphicon glyphicon-edit")
            end
   end
end
