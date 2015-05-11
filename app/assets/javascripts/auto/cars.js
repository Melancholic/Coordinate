$(document).on("page:change",car_init_list);

function car_card_toggle() {
    var dataFor = $(this).attr('data-for');
    var idFor = $(dataFor);
    var currentButton = $(this).find('div.dropdown-car i')
    idFor.slideToggle(400, function() {
        if(idFor.is(':visible')){
              currentButton.removeClass("glyphicon-plus");
              currentButton.addClass("glyphicon-minus"); 
          }
          else{
                currentButton.removeClass("glyphicon-minus");
                currentButton.addClass("glyphicon-plus"); 
            }
        })
}

function car_init_list() {
    var panels = $('.car-infos');
    var panelsButton = $('.dropdown-car');
    panels.hide();
    $('.car-row').click(car_card_toggle);
    $('[data-toggle="tooltip"]').tooltip();

    $('#car_color').colorselector();


}

function length_check(len_max, field_id, counter_id) { 
  var len_current = document.getElementById(field_id).value.length;
  var rest = len_max - len_current; 
  if (len_current > len_max ) {    
    document.getElementById(field_id).value = document.getElementById(field_id).value.substr (0, len_max); 
    if (rest < 0) { rest = 0;
  } 
    document.getElementById(counter_id).firstChild.data = rest + ' / ' + len_max; 
    BootstrapDialog.show({
        type: BootstrapDialog.TYPE_WARNING,
        title: 'Warning!',
        message: 'The maximum length of the field contents:  ' + len_max + ' symbols!',
    });
    } else {    
      document.getElementById(counter_id).firstChild.data = rest + ' / ' + len_max;   
    } 
  }

