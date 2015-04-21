jQuery('#cars').replaceWith("<%= escape_javascript(render('cars'))%>");
$('.pagination a').attr('data-remote', 'true');
car_init_list();