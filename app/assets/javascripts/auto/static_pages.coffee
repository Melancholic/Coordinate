# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "page:change", ->
  console.log( $(document).height() )
  console.log( $(window).height() );
  $('.pagination a').attr('data-remote', 'true')
  $('.custom_tooltip').tooltipster()
  if $(document).height() <= $(window).height()
    $("#footer").addClass("navbar-fixed-bottom")
    
